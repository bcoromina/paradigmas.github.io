#!/usr/bin/env bash
#
# generate_pdf.sh — Convert a Markdown file (with Mermaid diagrams) into a PDF.
#
# It renders any ```mermaid fenced code blocks into SVG images using
# @mermaid-js/mermaid-cli, converts the resulting Markdown to HTML with
# `marked`, wraps it in GitHub-like CSS, and prints it to PDF using
# Puppeteer (headless Chrome) with page numbers centered in the footer.
#
# Usage:
#   ./scripts/generate_pdf.sh README_EN.md [README_EN.pdf]
#
# Requirements:
#   - node/npx (https://nodejs.org)

set -euo pipefail

INPUT_MD="${1:-}"
if [[ -z "$INPUT_MD" || ! -f "$INPUT_MD" ]]; then
  echo "Usage: $0 <input.md> [output.pdf]" >&2
  exit 1
fi

OUTPUT_PDF="${2:-${INPUT_MD%.md}.pdf}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

MERMAID_DIR="$WORKDIR/mermaid"
mkdir -p "$MERMAID_DIR"

RENDERED_MD="$WORKDIR/rendered.md"
BODY_HTML="$WORKDIR/body.html"
FULL_HTML="$WORKDIR/full.html"

echo "==> Extracting Mermaid diagrams from $INPUT_MD"
python3 - "$INPUT_MD" "$RENDERED_MD" "$MERMAID_DIR" << 'PYEOF'
import re
import sys

input_md, rendered_md, mermaid_dir = sys.argv[1:4]

with open(input_md, "r", encoding="utf-8") as f:
    content = f.read()

pattern = re.compile(r"```mermaid\n(.*?)\n```", re.DOTALL)
blocks = pattern.findall(content)
print(f"Found {len(blocks)} mermaid block(s)")

for i, block in enumerate(blocks):
    with open(f"{mermaid_dir}/diagram_{i}.mmd", "w", encoding="utf-8") as f:
        f.write(block)

def replacer(match, counter=[0]):
    idx = counter[0]
    counter[0] += 1
    return f"![Diagram {idx}]({mermaid_dir}/diagram_{idx}.svg)"

new_content = pattern.sub(replacer, content)
with open(rendered_md, "w", encoding="utf-8") as f:
    f.write(new_content)
PYEOF

MERMAID_COUNT=$(find "$MERMAID_DIR" -name '*.mmd' | wc -l | tr -d ' ')
if [[ "$MERMAID_COUNT" -gt 0 ]]; then
  echo "==> Rendering $MERMAID_COUNT Mermaid diagram(s) to SVG"
  for mmd_file in "$MERMAID_DIR"/*.mmd; do
    svg_file="${mmd_file%.mmd}.svg"
    npx --yes @mermaid-js/mermaid-cli -i "$mmd_file" -o "$svg_file" -b transparent
  done
fi

echo "==> Converting Markdown to HTML"
npx --yes marked "$RENDERED_MD" > "$BODY_HTML"

echo "==> Wrapping HTML with styling"
python3 - "$BODY_HTML" "$FULL_HTML" << 'PYEOF'
import sys

body_html, full_html = sys.argv[1:3]

with open(body_html, "r", encoding="utf-8") as f:
    body = f.read()

html = """<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
  color: #24292e;
  max-width: 900px;
  margin: 40px auto;
  padding: 0 20px;
  line-height: 1.6;
  font-size: 15px;
}
h1, h2, h3, h4 { border-bottom: 1px solid #eaecef; padding-bottom: 0.3em; }
h1 { font-size: 2em; }
h2 { font-size: 1.5em; }
code {
  background-color: rgba(27,31,35,0.05);
  border-radius: 3px;
  padding: 0.2em 0.4em;
  font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, monospace;
  font-size: 85%;
}
pre {
  background-color: #f6f8fa;
  border-radius: 6px;
  padding: 16px;
  overflow: auto;
}
pre code { background-color: transparent; padding: 0; }
table {
  border-collapse: collapse;
  width: 100%;
  margin: 16px 0;
}
table th, table td {
  border: 1px solid #dfe2e5;
  padding: 6px 13px;
}
table tr:nth-child(2n) { background-color: #f6f8fa; }
img { max-width: 100%; }
hr { border: 0; border-top: 1px solid #eaecef; margin: 24px 0; }
blockquote {
  border-left: 0.25em solid #dfe2e5;
  color: #6a737d;
  padding: 0 1em;
  margin-left: 0;
}
a { color: #0366d6; text-decoration: none; }
</style>
</head>
<body>
""" + body + """
</body>
</html>
"""

with open(full_html, "w", encoding="utf-8") as f:
    f.write(html)
PYEOF

echo "==> Installing puppeteer (for PDF export with page numbers)"
PUPPETEER_DIR="$WORKDIR/puppeteer"
mkdir -p "$PUPPETEER_DIR"
npm install --no-save --prefix "$PUPPETEER_DIR" puppeteer --silent >/dev/null 2>&1

echo "==> Printing to PDF: $OUTPUT_PDF"
NODE_PATH="$PUPPETEER_DIR/node_modules" node "$SCRIPT_DIR/print_pdf.js" "$FULL_HTML" "$OUTPUT_PDF"

echo "==> Done: $OUTPUT_PDF"

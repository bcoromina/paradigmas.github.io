const puppeteer = require("puppeteer");
const path = require("path");

async function main() {
  const [, , inputHtmlPath, outputPdfPath] = process.argv;
  if (!inputHtmlPath || !outputPdfPath) {
    console.error("Usage: node print_pdf.js <input.html> <output.pdf>");
    process.exit(1);
  }

  const browser = await puppeteer.launch({
    headless: "new",
    args: ["--no-sandbox", "--disable-gpu"],
  });
  const page = await browser.newPage();
  await page.goto(`file://${path.resolve(inputHtmlPath)}`, {
    waitUntil: "networkidle0",
  });

  await page.pdf({
    path: outputPdfPath,
    format: "A4",
    printBackground: true,
    displayHeaderFooter: true,
    headerTemplate: "<span></span>",
    footerTemplate: `
      <div style="width:100%; font-size:9px; text-align:center; color:#6a737d; font-family:-apple-system,Helvetica,Arial,sans-serif;">
        <span class="pageNumber"></span>
      </div>
    `,
    margin: {
      top: "20mm",
      bottom: "20mm",
      left: "15mm",
      right: "15mm",
    },
  });

  await browser.close();
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});

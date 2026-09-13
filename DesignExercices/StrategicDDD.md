Absolutely. I’d make the scenario deliberately **ambiguous enough that students cannot simply map department → subdomain → bounded context**. The key is that the organizational structure is based on one axis, while the business capabilities and models are based on another.

Below is a self-contained case you can give students first, followed by a **teacher's answer key**.

---

# Strategic DDD Case Study: University Platform

## Part 1 — Context and Problem

### The University

**Global University** is a large international university with approximately 80,000 students.

It offers undergraduate, master's, and doctoral programs, both on campus and online.

Over the last few years, the university has grown significantly and has reorganized its technology and business departments.

The current organizational structure is:

```text
Global University
│
├── Undergraduate Division
│
├── Postgraduate Division
│
├── Online Education Division
│
├── Student Services Division
│
└── Finance Division
```

Each division has considerable autonomy and has its own product and engineering teams.

For example:

### Undergraduate Division

Responsible for everything related to undergraduate students:

* undergraduate admissions
* course enrollment
* student schedules
* exams
* grades
* tuition information
* student notifications

### Postgraduate Division

Responsible for:

* master's admissions
* master's enrollment
* thesis management
* exams
* grades
* tuition information
* student notifications

### Online Education Division

Responsible for:

* online program enrollment
* online course access
* online exams
* grades
* online payments
* notifications

The university originally built separate software systems for each division.

As a result, the technology landscape currently looks roughly like this:

```text
Undergraduate Division
        │
        └── Undergraduate Platform

Postgraduate Division
        │
        └── Postgraduate Platform

Online Education Division
        │
        └── Online Platform
```

However, the university has started experiencing significant problems.

---

## The Problems

The same concepts exist in multiple systems.

For example, all three platforms have something called a **Student**.

But they behave differently.

The Undergraduate system defines a student as:

> A person enrolled in at least one undergraduate program.

The Postgraduate system defines a student as:

> A person admitted to a postgraduate program.

The Online system defines a student as:

> A person with access to at least one online course.

The systems also have different concepts of **Enrollment**.

In the Undergraduate system:

> Enrollment means registering for a course during an academic semester.

In the Online system:

> Enrollment means purchasing access to an online course.

In the Postgraduate system:

> Enrollment is associated with joining a program and registering for its modules.

The university therefore has three different implementations of concepts such as:

* Student
* Enrollment
* Course
* Assessment
* Payment
* Notification

This has led to duplicated functionality and increasing integration problems.

---

# Organizational Reorganization

The university's management now wants to reorganize again.

Instead of organizing around education divisions, they want to organize around **student journeys**.

The proposed organization is:

```text
Global University
│
├── Recruitment & Admissions
│
├── Learning Experience
│
├── Assessment
│
├── Student Administration
│
└── Finance
```

The intention is that each department should be responsible for a particular part of the student's experience **across all types of students**.

For example:

### Recruitment & Admissions

Responsible for:

* attracting applicants
* applications
* admissions
* offers
* acceptance

### Learning Experience

Responsible for:

* courses
* learning materials
* course access
* schedules
* student progress

### Assessment

Responsible for:

* exams
* assignments
* grading
* assessment rules
* academic results

### Student Administration

Responsible for:

* student records
* enrollment administration
* program administration
* certificates

### Finance

Responsible for:

* tuition
* invoices
* payments
* refunds

The university expects the new structure to result in something like:

```text
Recruitment & Admissions
        │
        ├── Undergraduate
        ├── Postgraduate
        └── Online

Learning Experience
        │
        ├── Undergraduate
        ├── Postgraduate
        └── Online

Assessment
        │
        ├── Undergraduate
        ├── Postgraduate
        └── Online

Student Administration
        │
        ├── Undergraduate
        ├── Postgraduate
        └── Online

Finance
        │
        ├── Undergraduate
        ├── Postgraduate
        └── Online
```

The CTO asks your DDD team to perform a **Strategic DDD exercise**.

---

# Questions for Students

## Question 1 — Identify the Subdomains

What are the likely **subdomains** of Global University?

For each subdomain:

1. Give it a name.
2. Explain the business problem/capability it represents.
3. Classify it as:

    * Core
    * Supporting
    * Generic

Do **not** use the organizational departments as your answer without analysing whether they actually represent business subdomains.

---

## Question 2 — Identify the Bounded Contexts

Based on the domain analysis, propose the likely **Bounded Contexts**.

Explain:

* Which concepts belong to each context.
* Why those concepts form a coherent model.
* Where the boundaries between models should be.

---

## Question 3 — Should There Be One Bounded Context per Department?

The CTO proposes:

> "We now have five departments, so let's create five bounded contexts: Admissions, Learning, Assessment, Student Administration and Finance."

Do you agree?

Why or why not?

---

## Question 4 — What Should Happen to "Student"?

The word **Student** currently has several meanings.

Should the university create a single canonical `Student` model shared by the entire organization?

Explain your reasoning.

---

## Question 5 — What Should Happen to "Enrollment"?

The word **Enrollment** is currently used differently by Undergraduate, Postgraduate and Online Education.

Should there be one universal `Enrollment` model?

If not, how would you model the situation?

---

## Question 6 — Organization vs Domain

The new organizational structure is:

```text
Admissions
Learning
Assessment
Student Administration
Finance
```

Suppose your Strategic DDD analysis discovers:

```text
Admissions
Learning
Assessment
Student Administration
Finance
```

as the same five subdomains.

Does this mean the organizational structure is necessarily the correct way to define the bounded contexts?

Explain the distinction between:

* organizational department
* subdomain
* bounded context

---

## Question 7 — One Subdomain, Multiple Bounded Contexts

Suppose the **Assessment** subdomain contains two very different business models:

### Academic Assessment

* exams
* assignments
* grading
* academic integrity
* grade appeals

### Professional Certification

* certification exams
* certification attempts
* certification validity
* professional accreditation
* certificate renewal

They are both part of the university's Assessment business capability.

Would you necessarily create one Assessment Bounded Context?

Why might you create two?

---

## Question 8 — Multiple Subdomains, One Bounded Context

Consider the following two subdomains:

### Course Catalog

Responsible for:

* available courses
* course descriptions
* prerequisites
* course versions

### Learning Experience

Responsible for:

* course access
* learning materials
* student progress
* completion

The university currently has a small team and these two areas are tightly coupled.

Would it ever make sense to put both into a single Bounded Context?

What would you look at before making that decision?

---

## Question 9 — Who Owns the Bounded Context?

Suppose Strategic DDD identifies:

```text
                ┌─────────────────────┐
                │ Learning BC         │
                └─────────────────────┘
                   ↑       ↑       ↑
                   │       │       │
             Undergraduate Postgraduate Online
```

But the organization is still structured around:

```text
Undergraduate
Postgraduate
Online Education
```

Who should own the Learning Bounded Context?

Does DDD require the university to create a new "Learning Team"?

---

## Question 10 — The Reorganization Test

Imagine that the university **had performed Strategic DDD before the reorganization**.

At that time, the organization looked like:

```text
Undergraduate
Postgraduate
Online
```

Would you expect Strategic DDD to discover:

```text
Undergraduate BC
Postgraduate BC
Online BC
```

or something different?

Explain why.

---

# Teacher's Answer Key

## 1. Likely Subdomains

A strong answer would probably identify something like:

| Subdomain                 | Strategic classification              | Why                                                                         |
| ------------------------- | ------------------------------------- | --------------------------------------------------------------------------- |
| Recruitment & Admissions  | Supporting/Core depending on strategy | Acquiring and admitting students                                            |
| Learning Experience       | **Core**                              | Central to delivering the university's educational value                    |
| Assessment                | **Core**                              | Determines academic evaluation and outcomes                                 |
| Student Administration    | Supporting                            | Necessary to operate the university but usually not its main differentiator |
| Finance                   | Supporting / Generic                  | Important but unlikely to differentiate the university                      |
| Identity & Authentication | Generic                               | Commodity capability                                                        |
| Notifications             | Generic                               | Commodity capability                                                        |
| Payments                  | Generic                               | Often commodity infrastructure/service                                      |

The important thing is that **students should justify the classification** rather than merely label everything related to students as Core.

There is also no universally correct classification. For example, an online university could consider its Learning Experience highly differentiating while a certification institution might consider Assessment part of its core competitive advantage.

---

# 2. Likely Bounded Contexts

A reasonable model might be:

```text
Recruitment & Admissions BC
Learning BC
Assessment BC
Student Administration BC
Finance BC
```

But a particularly good student should explain that this is a **hypothesis**, not something automatically derived from the department names.

The boundaries should come from:

* ubiquitous language
* business rules
* model coherence
* ownership of concepts
* consistency requirements
* rate of change
* autonomy
* integration complexity

For example:

```text
                    UNIVERSITY
                        │
       ┌────────────────┼────────────────┐
       │                │                │
 Admissions         Learning        Assessment
       │                │                │
       └─────── Student Administration ───┘
                        │
                     Finance
```

The exact decomposition could legitimately differ if the students provide good reasoning.

---

# 3. Department ≠ Bounded Context

The correct answer is **no**.

The organizational department is an organizational concept.

A bounded context is a **model boundary**.

They can align, but they don't have to.

For example:

```text
Department                  Bounded Context
────────────────────────────────────────────
Learning                    Learning
```

could be a good alignment.

But this is also possible:

```text
Assessment Department
       │
       ├── Academic Assessment BC
       └── Certification BC
```

And:

```text
Course Catalog ─────┐
                    ├── Learning BC
Learning Experience ┘
```

So:

> **Don't derive the domain model from the org chart.**

---

# 4. Student

There should **not necessarily be one universal Student model**.

For example:

```text
Admissions BC

Applicant
AdmissionApplication
AdmissionOffer
```

Once admitted:

```text
Student Administration BC

Student
Enrollment
Program
```

And Learning may have:

```text
Learner
CourseAccess
LearningProgress
```

The same person can therefore appear as different concepts in different contexts.

This is not duplication that must automatically be eliminated.

It can be **intentional model separation**.

A particularly good answer might say:

> "Student" is a shared identity/person concept, but that doesn't imply that every context should share the same `Student` domain object.

---

# 5. Enrollment

This is an excellent test of whether students understand bounded contexts.

There should probably **not be one universal Enrollment model**.

For example:

```text
Student Administration BC

Enrollment
    student
    program
    academicPeriod
```

while:

```text
Learning BC

CourseAccess
    learner
    course
    accessPeriod
```

And perhaps:

```text
Online Commerce / Finance

CoursePurchase
    customer
    product
    payment
```

They may all refer to related business phenomena, but the models have different meanings and rules.

The important principle:

> Same word ≠ same concept.

And conversely:

> Different names ≠ necessarily different concepts.

Students should look at **meaning and rules**, not names.

---

# 6. Department vs Subdomain vs Bounded Context

This is probably the most important question.

### Department

An **organizational structure**.

It answers:

> "Who is responsible for what?"

### Subdomain

A **business/problem-space concept**.

It answers:

> "What business problem/capability exists?"

### Bounded Context

A **solution-space/model boundary**.

It answers:

> "Where does a particular domain model and language have a defined meaning?"

So:

```text
ORGANIZATION

Learning Department
        │
        ├── Course Catalog
        ├── Learning Experience
        └── Student Progress
```

doesn't automatically mean:

```text
Learning BC
```

Nor does:

```text
Learning Subdomain
```

automatically imply:

```text
Learning Department
```

These are three different dimensions.

---

# 7. One Subdomain → Multiple Bounded Contexts

**Yes, absolutely.**

This is a very good example.

You could have:

```text
Assessment Subdomain
        │
        ├── Academic Assessment BC
        │
        └── Professional Certification BC
```

Both belong to the same broader business capability, but their models may be substantially different.

For example:

```text
Academic Assessment

Exam
Assignment
Grade
GradeAppeal
AcademicIntegrityCase
```

versus:

```text
Professional Certification

CertificationExam
Attempt
Certification
ValidityPeriod
Renewal
```

They have different:

* language
* rules
* processes
* stakeholders
* lifecycles

Therefore separating them can make sense.

---

# 8. Multiple Subdomains → One Bounded Context

Also **yes**.

For example:

```text
Course Catalog ───────┐
                      ├── Learning BC
Learning Experience ──┘
```

This can make sense if the models are highly cohesive.

You should evaluate:

* How tightly coupled are the concepts?
* Do they use the same language?
* Do they change together?
* Do the same people understand both?
* Do they share business rules?
* Would separating them create expensive integration?
* Is there a meaningful boundary between the models?

A particularly good student should recognize that:

> A bounded context is not simply a container for one subdomain. It is a boundary around a coherent model.

---

# 9. Stewardship / Ownership

DDD does **not** say:

> One bounded context = one team.

Instead:

> A bounded context needs clear stewardship, and the organizational structure should support that stewardship.

Several solutions are possible.

### Option A — Learning Team

```text
Learning Team
      │
      └── Learning BC
           ↑    ↑    ↑
        Under Post  Online
```

Very clean.

### Option B — Shared ownership

The university could establish a cross-division team responsible for the Learning BC.

### Option C — Segment teams

If Undergraduate, Postgraduate and Online genuinely have different Learning models, the university might eventually discover:

```text
Undergraduate Learning BC
Postgraduate Learning BC
Online Learning BC
```

The important point is that **team boundaries should be evaluated against the domain boundaries**, rather than blindly assuming either one determines the other.

---

# 10. The Reorganization Test

This is the key strategic DDD question.

If Strategic DDD had been performed **before** the reorganization, we should **not automatically expect**:

```text
Undergraduate BC
Postgraduate BC
Online BC
```

We might instead have discovered:

```text
Admissions BC
Learning BC
Assessment BC
Student Administration BC
Finance BC
```

because the **business capabilities existed independently of the organizational structure**.

The old organization:

```text
Undergraduate
Postgraduate
Online
```

was one way of structuring the people.

It does not necessarily represent the structure of the domain.

After the reorganization:

```text
Admissions
Learning
Assessment
Student Administration
Finance
```

the organization happens to look more like the domain decomposition.

But that doesn't prove that the organizational structure created the domain boundaries.

It may simply mean that management eventually reorganized around the same business capabilities that DDD would have discovered.

---

# The Core Lesson for Students

I'd make this the conceptual objective of the exercise:

```text
             PROBLEM SPACE
                  │
                  ▼
             SUBDOMAINS
                  │
                  ▼
        ┌───────────────────┐
        │ Domain modelling  │
        │ language + rules  │
        └───────────────────┘
                  │
                  ▼
          BOUNDED CONTEXTS
                  │
                  ▼
             SOLUTION SPACE
                  │
                  ▼
              SOFTWARE
```

while separately:

```text
             ORGANIZATION
                  │
        ┌─────────┴─────────┐
        ▼                   ▼
     Teams             Departments
```

These two structures **influence each other**, but they are not the same thing.

And this is where **Conway's Law** becomes interesting:

> The organization and the software architecture tend to influence each other.

So the strategic DDD question isn't:

> **"How do we make the bounded contexts match the departments?"**

It is:

> **"What are the meaningful business boundaries, what models belong inside them, and what organizational structure will allow us to steward those boundaries effectively?"**

That distinction is exactly what I'd expect the strongest students to identify.

---
id: "doc:guides/markdown-authoring-rules"
fileExtension: "md"
title: "Markdown Authoring Rules for AI Collaboration"
artifactVersion: "1.1.0"
status: "Active"
summary: "Provides a set of strict, machine-enforceable formatting rules for AI assistants to ensure all generated Markdown is compliant with the project's `markdownlint` standards."
usageGuidance:
  - "This document should be referenced in prompts given to AI assistants when asking for Markdown generation."
  - "The rules herein are based on the project's `markdownlint` configuration."
owner: "Canon"
createdDate: "2025-06-08T13:15:00Z"
lastModifiedDate: "2025-06-08T13:30:00Z"
tags:
  - "guide"
  - "process"
  - "linting"
  - "markdown"
  - "ai-collaboration"
  - "standards"
---
# Markdown Authoring Rules for AI Collaboration

## 1. Purpose

This document provides a set of explicit, machine-enforceable rules for AI assistants generating Markdown content for the THEA project. The primary goal is to ensure that all AI-generated content is **100% compliant** with our `markdownlint` configuration from the moment of its creation, eliminating the need for manual, iterative formatting corrections.

When prompted to create Markdown, you **MUST** adhere to every rule listed below.

## 2. Core Formatting Rules (`markdownlint`)

These rules correspond directly to our linting configuration.

### Rule: MD022 / blanks-around-headings

All headings (e.g., `##`, `###`) MUST be surrounded by a single blank line. There must be one blank line before the heading and one blank line after it.

- **Correct:**

  ```markdown
  ...previous paragraph.

  ## A Section Title

  The first paragraph of the section...
  ```

- **Incorrect:**

  ```markdown
  ...previous paragraph.
  ## A Section Title
  The first paragraph of the section...
  ```

### Rule: MD030 / list-marker-space

All list items (`-` or `*`) MUST be followed by exactly one space.

- **Correct:**

  ```markdown
  - A list item.
  - Another list item.
  ```

- **Incorrect:**

  ```markdown
  -  A list item with two spaces.
  -   A list item with three spaces.
  ```

### Rule: MD032 / blanks-around-lists

All list blocks (`ul` or `ol`) MUST be surrounded by a single blank line. This means there must be one blank line before the first list item and one blank line after the last list item.

- **Correct:**

  ```markdown
  ...previous paragraph.

  - A list item.
  - Another list item.

  The next paragraph...
  ```

- **Incorrect:**

  ```markdown
  ...previous paragraph.
  - A list item.
  - Another list item.
  The next paragraph...
  ```

### Rule: MD036 / no-emphasis-as-heading

You MUST NOT use emphasized text (bold or italics) as a substitute for a heading. Section titles must use proper Markdown heading syntax (e.g., `##`).

- **Correct:**

  ```markdown
  ## 3. A Real Section Title
  ```

- **Incorrect:**

  ```markdown
  **3. A Fake Section Title**
  ```

### Rule: MD007 / ul-indent

All unordered list items MUST be indented with 2 spaces for sub-lists.

- **Correct:**

  ```markdown
  - Top level item.
    - Second level item.
  ```

- **Incorrect:**

  ```markdown
  - Top level item.
      - Second level item indented too far.
  ```

### Rule: MD031 / blanks-around-fences

All fenced code blocks (e.g., ` ``` `) MUST be surrounded by a single blank line.

- **Correct:**

  ```markdown
  ...text before.

  ```

  code here

  ```

  ...text after.
  ```

### Rule: MD040 / fenced-code-language

All fenced code blocks MUST have a language identifier specified.

- **Correct:**

  ```markdown
  ```markdown
  # This is markdown
  ```

- **Incorrect:**

  ```  # This has no language
  ```

### Rule: MD047 / single-trailing-newline

Every generated file MUST end with a single blank line (a single trailing newline character).

## 3. Invocation in Prompts

When requesting Markdown generation, a user may simply reference this guide.

**Example Prompt:**
> "Please create a playbook for XYZ. The content should be... **Ensure the output strictly adheres to the standards defined in `docs/guides/markdown-authoring-rules.md`.**"

This instruction signals to you that you must follow these rules with maximum priority.

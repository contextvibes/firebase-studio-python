---
id: "playbook:process/documentation-finalization"
fileExtension: "md"
title: "Playbook: Documentation Finalization"
artifactVersion: "1.0.0"
status: "Active"
summary: "Defines the final, automated steps a contributor must take to ensure a Markdown document is compliant with project standards before submitting a Pull Request."
usageGuidance:
  - "Follow this playbook after the content of a document is complete but before you create a Pull Request."
owner: "Canon, Kernel"
createdDate: "2025-06-08T13:45:00Z"
lastModifiedDate: "2025-06-08T13:45:00Z"
tags:
  - "playbook"
  - "process"
  - "linting"
  - "markdown"
  - "quality-assurance"
  - "finalization"
  - "automation"
---
# Playbook: Documentation Finalization

## 1. Purpose

This playbook defines the mandatory final steps for preparing any Markdown document for submission. Its purpose is to decouple the creative process of content generation from the mechanical process of format enforcement.

Instead of requiring AI assistants or human authors to perfectly remember every formatting rule, we rely on automated tooling to enforce compliance. Following this process ensures that all submitted documentation is 100% compliant with our quality standards with minimal manual effort.

This playbook should be executed after the document's content is considered complete and before a Pull Request is created.

## 2. Prerequisites (Tooling)

This process relies on the `markdownlint-cli` tool being available in the development environment.

- **Environment:** `Sparky` is responsible for ensuring `pkgs.markdownlint-cli` is included in the project's `.idx/dev.nix` file.
- **In-Editor (Optional but Recommended):** The `davidanson.vscode-markdownlint` extension provides real-time feedback during authoring and can be configured to fix issues on save.

## 3. The Finalization Process

### Step 1: Save the Completed Document

Ensure all your content changes are saved in the relevant Markdown file. At this stage, do not worry about perfect formatting. Focus on the quality and accuracy of the content itself.

### Step 2: Run the Automated Formatting Command

Open a terminal in Firebase Studio and run the following command, replacing `path/to/your/document.md` with the actual file path of the document you have just finished editing:

```bash
markdownlint --fix path/to/your/document.md
```

**What this command does:**
The `--fix` flag instructs the `markdownlint` tool to automatically correct every formatting error that it can, such as list spacing, indentation, and blank lines around headings and code blocks.

To fix all modified markdown files at once, you can use a more general command:

```bash
markdownlint --fix "**/*.md"
```

### Step 3: Briefly Review the Changes

After the command runs, your file will be modified. Give the document a quick visual scan to ensure that the auto-formatting did not inadvertently change the meaning of your content (this is very rare, but a quick review is always good practice).

### Step 4: Commit and Create Pull Request

The document is now fully compliant with the project's formatting standards. You can now commit the file and proceed with creating your Pull Request.

```bash
git add path/to/your/document.md
git commit -m "docs: Finalize content for [document title]"
git push
```

By adopting this playbook, we streamline our workflow, focusing our creative energies on content and letting the tools handle the rest.

---
id: "guide:style-guide"
fileExtension: "md"
title: "THEA Contributor Style Guide"
artifactVersion: "1.2.0" # Version bump for metadata update
status: "Active"
summary: "The definitive guide defining content standards for the THEA framework, including filename conventions, artifact status lifecycle, and other stylistic rules."
usageGuidance:
  - "Consult this guide before creating or modifying any new files or documentation to ensure consistency."
  - "Primary reference for the 'lowercase-kebab-case' filename convention."
owner: "Canon"
createdDate: "2025-06-07T12:00:00Z"
lastModifiedDate: "2025-06-13T05:02:00Z" # Reflects current update time
tags:
  - "style-guide"
  - "standards"
  - "documentation"
  - "contribution"
  - "process"
  - "naming-convention"
  - "lifecycle"
---
# THEA Contributor Style Guide

**Version:** 1.1
**Status:** Active
**Conceptual Owner:** `Canon`

## 1. Purpose

This document provides essential style and formatting guidelines for all contributors to the THEA framework. Adhering to these standards ensures consistency, clarity, and maintainability across the entire project, making our artifacts easier to read, navigate, and manage.

## 2. Artifact Metadata (Front Matter)

All formal artifacts (documents, playbooks, schemas) MUST begin with a YAML front matter block that conforms to the `thea_artifact_metadata_schema.json`.

### 2.1. Artifact Status

The `status` field is mandatory and defines the artifact's position in its lifecycle. Use one of the following values:

- **`Draft`**: A work-in-progress, not yet ready for general use or review.
- **`Proposed`**: Ready for review by the team. The content is complete but not yet officially approved.
- **`Active`**: The official, current version of the artifact. It should be used and adhered to.
- **`Deprecated`**: The artifact is outdated and scheduled for removal. It should be avoided, and its replacement should be referenced.
- **`Archived`**: No longer in use but kept for historical context. It should not be deleted.

## 3. Filename Conventions

To ensure cross-platform compatibility, prevent linking issues, and reduce cognitive load, all files created within this project must adhere to a standardized naming convention.

### 3.1. The Standard: `lowercase-kebab-case`

All new files and directories MUST use **lowercase-kebab-case**.

- **Description:** This means all letters are lowercase, and words are separated by hyphens (`-`).
- **Correct Examples:**
  - `docs/guides/new-user-guide.md`
  - `thea/schemas/artifact-metadata-schema.json`
  - `playbooks/process-guidance/managing-project-diagrams.md`
- **Incorrect Examples:**
  - `NewUserGuide.md` (PascalCase)
  - `newUserGuide.md` (camelCase)
  - `new_user_guide.md` (snake_case)
  - `New user guide.md` (contains spaces)

### 3.2. Exceptions

A few specific, universally recognized root-level files SHOULD retain their conventional casing. This is because they are often treated specially by Git hosting platforms, build tools, or community expectations.

**The only exceptions are:**

- `README.md`
- `LICENSE`
- `CONTRIBUTING.MD` (or `CONTRIBUTING.md`)
- `CHANGELOG.MD` (or `CHANGELOG.md`)

All other files in all other directories MUST follow the `lowercase-kebab-case` standard.

### 3.3. Adoption Policy

A full, immediate renaming of all existing files is not required as it would create unnecessary noise in the Git history. Instead, we will follow a "going forward" policy:

1. **All new files** MUST be created using the `lowercase-kebab-case` standard.
2. **Existing files** that do not conform to the standard SHOULD be renamed **opportunistically** when they are next undergoing significant modification or review. Do not create a Pull Request solely for renaming files.

## 4. Markdown Linting and Quality

To automate the enforcement of Markdown standards, this project uses `markdownlint`.

### 4.1. Development Environment Integration

To provide immediate feedback, the `markdownlint-cli` tool is integrated into the Firebase Studio development environment via the project's `.idx/dev.nix` file. This is managed by `Sparky`.

The `davidanson.vscode-markdownlint` VS Code extension is also a recommended part of the workspace configuration to provide real-time, in-editor highlighting of any issues.

### 4.2. Contributor Responsibility

All contributors are expected to resolve any `markdownlint` errors reported in the editor before submitting a Pull Request. This ensures that all committed documentation adheres to our shared quality standards from the beginning.

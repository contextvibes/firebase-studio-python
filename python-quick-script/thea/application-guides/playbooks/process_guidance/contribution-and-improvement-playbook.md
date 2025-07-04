---
id: "playbook:process/contribution-and-improvement"
fileExtension: "md"
title: "Playbook: THEA Contribution and Improvement Process"
artifactVersion: "1.0.1" # Patch for date update
status: "Active"
summary: "Defines the detailed, step-by-step process for submitting, reviewing, and implementing ideas to improve the THEA framework, using GitHub Issues and the project's Scrum methodology."
usageGuidance:
  - "This playbook provides the full process details for core team members and dedicated contributors."
  - "Consult this to understand the lifecycle of an idea from submission to implementation."
owner: "Orion, Athena"
createdDate: "2025-06-13T04:41:00Z"
lastModifiedDate: "2025-06-13T04:59:00Z" # Reflects current update time
tags:
  - "playbook"
  - "process"
  - "contribution"
  - "governance"
  - "github"
  - "scrum"
---
# Playbook: THEA Contribution and Improvement Process

## 1. Purpose

This playbook provides the detailed, step-by-step workflow for contributing ideas to the THEA framework. It is designed to be transparent, efficient, and to ensure that all valuable proposals are formally reviewed and actioned. This process applies to both internal core team members and external collaborators.

## 2. The Contribution Workflow

### Step 1: Idea Submission via GitHub Issue

- **Action:** Any person with an idea for a new feature, improvement, bug fix, or documentation update should open a **GitHub Issue** in the THEA repository.
- **Templates:** Use the provided GitHub Issue Templates (`Idea / Improvement Proposal`, `Bug Report`, etc.) to structure your submission. This ensures all necessary information is provided upfront.
- **Context is Key:** For bug reports or ideas related to tooling behavior, please run `contextvibes describe` and include the relevant output in your issue description to provide our team with the necessary context.
- **Notification:** After submission, please `@mention` `Orion` and `Athena` in the issue to trigger the review process.

### Step 2: Triage and Strategic Review

- **Action:** `Orion` (as Product Owner) and `Athena` (as AI Strategy Lead) will review the submitted issue.
- **Process:** They will assess the idea's value, feasibility, and alignment with THEA's strategic goals. They will communicate the status using the following labels on the issue:
  - `status: under-review`: The idea is actively being considered.
  - `status: accepted`: The idea is approved for the backlog.
  - `status: declined`: The idea will not be pursued at this time. A reason will be provided.
  - `status: needs-more-info`: The reviewers require more information from the submitter.

### Step 3: Formalization into a Product Backlog Item (PBI)

- **Action:** Once an idea is labeled `status: accepted`, a core team member will create a new, formal **PBI Issue**.
- **Process:**
  - This new PBI Issue will use our detailed PBI format, clearly defining the goal, scope, and acceptance criteria.
  - The original idea issue will be closed with a comment linking to the new PBI Issue for traceability.

### Step 4: Implementation via Scrum Process

- **Action:** The PBI now officially enters the Product Backlog.
- **Process:** It will be prioritized by `Orion` and pulled into a Sprint according to our standard agile workflow, as detailed in **`docs/process/agile-framework-development.md`**.

## 3. Special Case: `ContextVibes CLI` Improvements

- If your idea is a feature request or bug report for the `ContextVibes CLI` tool itself, the process is slightly different.
- **Action:**
  1. Still, first submit the idea to the **THEA GitHub Issues** for strategic review by `Orion` and `Athena`.
  2. If accepted, the idea will be passed to `Nexus` (ContextVibes CLI Liaison).
  3. `Nexus` will be responsible for creating a formal issue in the **separate `ContextVibes CLI` repository's issue tracker**, translating our internal need into a clear requirement for that tool's development team.

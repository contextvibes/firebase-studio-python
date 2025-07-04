---
id: "playbook:process/framework-release"
fileExtension: "md"
title: "Playbook: THEA Framework Release"
artifactVersion: "1.1.0" # Version bump for metadata update
status: "Active"
summary: "Provides the standard, step-by-step checklist for tagging, documenting, and communicating a new release of the THEA framework."
usageGuidance:
  - "This playbook MUST be followed for all official versioned releases of the THEA framework."
  - "Use this to understand the process for updating the CHANGELOG.md and creating Git tags."
owner: "Orion, Canon"
createdDate: "2025-06-08T20:00:00Z"
lastModifiedDate: "2025-06-13T05:00:00Z" # Reflects current update time
tags:
  - "playbook"
  - "process"
  - "release"
  - "versioning"
  - "changelog"
  - "governance"
---
# Playbook: THEA Framework Release

## 1. Purpose

This playbook provides the standard checklist and procedure for creating an official, versioned release of the THEA framework. Following this process ensures that every release is consistent, well-documented, and clearly communicated to all stakeholders.

This process is owned by `Orion` (as the ultimate approver) and managed by `Canon` (as the keeper of standards and changelogs).

## 2. Pre-Release Checklist

Before starting the release process, ensure the following conditions are met:

- [ ] **All planned features and fixes for this release are merged into the `main` branch.** The `main` branch is considered stable and ready for release.
- [ ] **All automated checks (CI/CD) are passing on the `main` branch.** This includes tests, linters, and any other quality gates.
- [ ] **The Product Owner (`Orion`) has given formal approval to proceed with the release.**

## 3. The Release Process

### Step 1: Determine the New Version Number

- **Action:** Based on the changes since the last release, determine the new version number following **Semantic Versioning (SemVer)** rules.
  - **MAJOR** (e.g., v1.x.x -> v2.0.0): For incompatible, breaking changes.
  - **MINOR** (e.g., v1.1.x -> v1.2.0): For new, backward-compatible functionality.
  - **PATCH** (e.g., v1.1.1 -> v1.1.2): For backward-compatible bug fixes.
- **Owner:** `Orion` makes the final decision.

### Step 2: Create a Release Branch

- **Action:** Create a new release branch from the `main` branch.

  ```bash
  git checkout main
  git pull origin main
  git checkout -b release/vX.Y.Z
  ```

  *(Replace `vX.Y.Z` with the new version number, e.g., `release/v0.4.0`)*.
- **Rationale:** All release-specific changes (changelog, version bumps) will happen on this branch to keep `main` clean.

### Step 3: Update the Changelog

A changelog is critical for communicating changes to users.

- **Action (if `CHANGELOG.md` doesn't exist):** Create a new file named `CHANGELOG.md` at the project root, following the "Keep a Changelog" format.
- **Action (if `CHANGELOG.md` exists):**
  1. Rename the `[Unreleased]` section to `[vX.Y.Z] - YYYY-MM-DD`.
  2. Add a new, empty `[Unreleased]` section at the top.
  3. Review and refine the changelog entries for the new version. Ensure they are user-centric and clear.
- **Owner:** `Scribe`, with review from `Canon`.

### Step 4: Update Internal Version Numbers

- **Action:** Identify and update any files that contain the framework's version number.
  - `airules.md` (the version in the main title).
  - Any other key documents or manifest files.
- **Owner:** `Scribe` or the relevant artifact owner.

### Step 5: Create and Merge the Release Pull Request

- **Action:**
  1. Commit the updated changelog and any other versioned files to the release branch.
  2. Push the release branch to the remote repository.
  3. Open a Pull Request from the `release/vX.Y.Z` branch to `main`.
  4. The PR description should state "Release PR for vX.Y.Z."
  5. At least one other core team member (e.g., `Athena`) must review and approve the PR.
  6. Once approved, merge the PR into `main`.

### Step 6: Tag the Release

This is the official act of creating the release.

- **Action:**
  1. Pull the latest changes to your local `main` branch.

     ```bash
     git checkout main
     git pull origin main
     ```

  2. Create an **annotated Git tag**. The tag name must start with `v`.

     ```bash
     git tag -a vX.Y.Z -m "Release vX.Y.Z"
     ```

  3. Push the tag to the remote repository.

     ```bash
     git push origin vX.Y.Z
     ```

- **Owner:** `Orion` or a designated release manager.

### Step 7: Post-Release Communication

- **Action:** Announce the new release to the team via the appropriate channels (e.g., Slack, email). The announcement should include a link to the `CHANGELOG.md` section for the new version.
- **Owner:** `Helms` or `Orion`.

```

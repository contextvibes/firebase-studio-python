# Playbook: Capturing Lessons Learned with AI Collaboration (User-Mediated Document Flow)

**Version:** 1.0
**Date:** 2025-06-06
**Status:** Draft
**Primary Author (Conceptual):** `Scribe`
**Contributors (Conceptual):** `Athena`, `Kernel`, `Helms`, `Canon`
**Related PBI:** `PBI-THEA-Process-005` (or specific PBI ID)

## 1. Purpose & Scope

This playbook outlines the practical, step-by-step process for capturing "lessons learned" when collaborating with the THEA Collective AI (or similar AI assistants where direct file system access is not possible). In this model, the **user acts as the crucial intermediary** for all file creation and updates within the THEA project repository.

The process described here is designed to ensure that insights and generated content are accurately transferred to THEA's knowledge base, utilizing `ContextVibes CLI` for conceptual validation by the AI before formal submission. This playbook applies to lessons learned and documentation generated for:

* THEA framework improvements (artifacts, documentation, `airules.md`).
* `ContextVibes CLI` feedback and usage patterns.
* Specific ongoing projects utilizing THEA and ContextVibes.

Adherence to this playbook promotes reliability, shared understanding, and effective integration of AI-assisted knowledge capture.

## 2. Guiding Principles

* **User as Agent:** The user is responsible for all direct file manipulations and Git operations.
* **AI as Generator & Conceptual Validator:** The THEA Collective AI generates content and, using user-provided `ContextVibes CLI describe` snapshots, conceptually validates that the generated information has been correctly staged by the user locally.
* **Clarity & Explicitness:** All steps should be clear to both the user and the AI.
* **Iterative Refinement:** This process itself is subject to improvement based on lessons learned.

## 3. Key Personas Involved (Conceptual)

* **User:** The developer interacting with the THEA Collective and the THEA repository.
* **THEA Collective (AI):** The AI assistant generating content and performing conceptual validation.
  * `Kernel`: Provides guidance on `ContextVibes CLI` usage.
  * `Athena`: Guides AI strategy and process flow.
  * `Scribe`: (Channeled by AI) Ensures clarity in generated documentation.
  * `Canon`: (Channeled by AI) Advises on standards for generated documentation.
* **THEA Human Team (for PR Review):** `Orion`, `Athena`, `Helms`, `Kernel`, `Scribe`, `Canon`, `Logos`, `Nexus`, etc., as appropriate for the specific content being reviewed.

## 4. Step-by-Step Process

Here is the standard workflow for capturing a lesson learned or co-creating a document with the THEA Collective AI:

### Step 1: Identify Lesson & Define Target Artifact

* **Action (User & THEA Collective):** Through discussion, a lesson learned is identified, or a need for a new/updated THEA document (e.g., guide, playbook, `airules.md` suggestion, `GLOSSARY.md` term) is established.
* **Output:** Clear agreement on what information needs to be captured and what the target file/artifact will be (including its path in the THEA repository).
* **Example:** "We've learned that the `ContextVibes CLI describe` command is crucial for AI context. Let's create a user guide for it at `docs/user-guides/contextvibes_cli_ai_context_guide.md`."

### Step 2: AI Generates Content

* **Action (THEA Collective):** Based on the defined need, the THEA Collective AI generates the full Markdown content for the new document or the specific textual changes for an existing document.
* **Output:** The AI provides the complete text content in the chat interface.
* **Example:** The AI outputs the full Markdown for the `contextvibes_cli_ai_context_guide.md`.

### Step 3: User Creates/Updates File Locally

* **Action (User):**
    1. If not already on a suitable feature branch, check out a new, descriptively named branch (e.g., `git checkout -b feat/docs-new-cli-guide`).
    2. **Copy** the complete content provided by the THEA Collective in Step 2.
    3. Navigate to the target directory in your local THEA repository.
    4. **Create a new file** with the agreed-upon name and path, or **open the existing file** that needs updating.
    5. **Paste** the copied content into the file.
    6. **Save** the file.
* **Output:** The new/updated file exists locally with the AI-generated content.

### Step 4: User Commits Changes Locally (Recommended)

* **Action (User):** It's good practice to commit the changes locally at this stage.

    ```bash
    git add path/to/your/new_or_updated_file.md
    git commit -m "docs: Draft content for [artifact name] - [PBI if applicable]"
    ```

    *(Adjust commit message as per THEA's conventions, referencing PBIs where possible.)*
* **Output:** Local commit created on your feature branch.

### Step 5: User Generates Context Snapshot with `ContextVibes CLI`

* **Action (User):** To enable conceptual validation by the AI, generate a fresh project snapshot using `ContextVibes CLI`.

    ```bash
    ./bin/contextvibes describe -o lesson_capture_review.md
    ```

    *(Using a distinct output filename like `lesson_capture_review.md` or `temp_validation_context.md` is recommended to avoid overwriting a primary `contextvibes.md` you might be using for other purposes.)*
* **Output:** A new Markdown file (e.g., `lesson_capture_review.md`) containing the current project state, including your newly saved local file.

### Step 6: User Shares Snapshot with AI

* **Action (User):**
    1. Open the generated snapshot file (e.g., `lesson_capture_review.md`).
    2. **Copy its entire content.**
    3. **Paste the entire content** into the chat interface with the THEA Collective AI.
    4. Prompt the AI: "Kernel/THEA Collective, please review this updated project context. Does it appear that the content for `path/to/your/new_or_updated_file.md` has been captured as we discussed?"
* **Output:** The AI receives the latest project snapshot.

### Step 7: AI Performs Conceptual Validation

* **Action (THEA Collective, channeling `Kernel`, `Scribe`):**
    1. The AI analyzes the provided snapshot from Step 6.
    2. It checks if the target file (`path/to/your/new_or_updated_file.md`) is present in the snapshot's file listing.
    3. It compares the content of that file *within the snapshot* against the content it originally generated in Step 2.
    4. It checks the Git Status section of the snapshot to see if the file is committed (if Step 4 was done) or if it shows as untracked/modified.
    5. The AI provides feedback to the user:
        * Confirmation if the content appears to be captured correctly.
        * Notification if the file is missing or if the content seems different, with suggestions on how to verify.
* **Output:** AI feedback on the conceptual validation.
* **Example AI Response:** "Yes, based on the `lesson_capture_review.md` snapshot, the file `docs/user-guides/contextvibes_cli_ai_context_guide.md` is present, and its content aligns with the guide we drafted. The Git status also indicates it's now part of your local commit. You should be good to proceed with the PR."

### Step 8: User Proceeds with Pull Request

* **Action (User):** Once conceptual validation is satisfactory:
    1. Ensure all necessary local commits are made on the feature branch.
    2. Push the feature branch to the remote repository:

        ```bash
        git push origin your-feature-branch-name
        ```

    3. Create a Pull Request (PR) on GitHub (or equivalent platform) from your feature branch to `main` (or the designated integration branch), following THEA's `CONTRIBUTING.MD` guidelines.
        * Use `gh pr create` or the web UI.
        * Write a clear PR title and description, referencing any relevant PBI.
        * Request reviews from the appropriate THEA human team members/personas.
* **Output:** A Pull Request is created.

### Step 9: Human Team Reviews and Merges PR

* **Action (THEA Human Team):** Designated reviewers (`Orion`, `Athena`, `Scribe`, `Canon`, `Kernel`, etc.) perform a formal review of the PR for technical accuracy, documentation standards, strategic alignment, and overall quality.
* **Iteration:** If feedback is given, the user addresses it by making further commits to the feature branch (which automatically updates the PR).
* **Merge:** Once approved, the PR is merged into the `main` branch by a maintainer.
* **Output:** The new/updated documentation or lesson learned is now officially part of THEA.

### Step 10: Update Knowledge Base Index

* **Action (`Canon`, `Scribe`):** For any new significant guide, playbook, or learning resource, ensure an entry is made in `docs/KNOWLEDGE_BASE_INDEX.MD` to make it discoverable. This might be part of the original PR or a follow-up.
* **Output:** Updated and accessible knowledge base.

## 5. Conclusion

This user-mediated document flow, while involving manual steps for file transfer, provides a robust method for collaborating with the THEA Collective AI to capture and integrate valuable lessons learned and documentation into the THEA project. The use of `ContextVibes CLI describe` for conceptual validation is a key component in ensuring accuracy before formal review.

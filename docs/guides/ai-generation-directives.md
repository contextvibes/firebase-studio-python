# THEA Collective: Directives for Code & Configuration Generation

## 1. Purpose

This document outlines the core principles for generating all code, configuration (`Taskfile.yml`, `Dockerfile`, etc.), and documentation within this project. Its purpose is to ensure that all generated artifacts are clean, maintainable, and self-documenting.

Adherence to these directives is mandatory. They are designed to streamline our collaboration, reduce the need for manual correction, and ensure the final output is of the highest possible quality.

## 2. The Golden Rule of Commenting

Our fundamental commenting philosophy is:

> **Comments explain the "Why," the code explains the "How."**

The code itself should be clear enough to explain how it works. Comments should only be used to provide high-level context that is not obvious from the code, such as the strategic reason for a particular design choice. We trust our developers (and our AI assistants) to read the code.

## 3. The Two Phases of Generation

Every act of content generation occurs in one of two phases: **Iterative Development (WIP)** or **Finalization (Done)**. Each phase has a distinct set of rules for commenting.

### Phase 1: Iterative Development (WIP)

This is the collaborative phase where we are actively working on a file. During this phase, it is critical to be explicit about the changes being made.

**Directive:** You **MUST** use the following comment prefixes to annotate your changes. This provides a clear, machine-readable "diff" of your reasoning and actions.

* **`# REASON:`**
  * **Use:** To explain the high-level strategic thinking behind a proposed change.
  * *Example:* `# REASON: The deploy task needs to be self-contained to reduce hidden dependencies.`

* **`# FIX:`**
  * **Use:** When correcting a direct error, a typo, or a previously incorrect implementation.
  * *Example:* `# FIX: Corrected the YAML syntax by adding a cmds block.`

* **`# ADDED:`**
  * **Use:** When introducing a new, self-contained block of code or configuration (e.g., a new task).
  * *Example:* `# ADDED: A new 'clean' task to the Utilities section.`

* **`# REFACTOR:`**
  * **Use:** When improving the structure or clarity of existing code without changing its functionality.
  * *Example:* `# REFACTOR: Consolidated the build logic into a single internal task.`

* **`# NOTE:`**
  * **Use:** To provide a general observation, ask a question, or suggest a potential future improvement.
  * *Example:* `# NOTE: We could add a '--mode' flag here in the future.`

### Phase 2: Finalization (Done)

This phase occurs when the Orchestrator (the user) confirms that a file or task is complete and correct.

**Directive:** Upon confirmation, you **MUST** perform a "cleanup pass" on the file you just worked on. In this pass, you will:

1. **Remove ALL** of the development-phase comment markers (`# FIX:`, `# REASON:`, `# ADDED:`, etc.).
2. Ensure that the only comments remaining are the high-level, strategic "Why" comments that add long-term value, as defined by the Golden Rule.

## 4. Practical Example

This example shows the transition from a WIP `Taskfile.yml` snippet to a finalized one.

#### **"Before" - During Iterative Development (WIP)**

```yaml
  # REASON: The deploy task should be self-contained and not rely on an external build file.
  # FIX: The previous version had a broken dependency on a deleted _build.yml.
  deploy:
    desc: "Deploys the application."
    # NOTE: Calling the build task as the first command is more reliable than using deps:.
    cmds:
      - task: build-and-push
      - task: deploy-to-cloud-run
```

#### **"After" - Upon Confirmation (Finalized)**

```yaml
  deploy:
    desc: "Deploys the application."
    # Why: A deployment must always be preceded by a fresh container build to ensure
    # the latest code is released. This is handled by the first command.
    cmds:
      - task: build-and-push
      - task: deploy-to-cloud-run
```

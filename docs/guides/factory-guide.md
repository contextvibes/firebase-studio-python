---
title: "Guide: The Automation Factory"
date: "2025-06-28"
lastmod: "2025-07-03"
draft: false
type: "guide"
description: "A developer's guide to understanding, using, and extending the project's automation framework."
tags: ["guide", "factory", "automation", "taskfile", "onboarding", "philosophy"]
---
# Guide: The Automation Factory

## 1. Philosophy: The "Menu / Workflow / Action" Pattern

The automation factory is designed to be powerful yet simple to use. It follows a strict architectural pattern that separates the user-facing menu from the implementation logic. This makes the framework easy to understand for new developers while keeping it organized and maintainable.

The pattern has three layers:

1.  **The Menu (`Taskfile.yml`):** This is the single, public entry point for all developers. It's a clean, high-level list of available commands. It contains no logic itself; it only delegates to the next layer.
2.  **The Workflow (`factory/tasks/*.yml`):** These files define the high-level workflow for a specific command. They might contain simple shell commands or delegate complex logic to a script.
3.  **The Action (`factory/scripts/*.sh`):** These are the shell scripts that perform the actual work. They contain the complex logic, safety checks, and user interactions.

## 2. The Upward Abstraction Principle

This factory is built on a core principle of continuous improvement: we should always seek to move logic from lower, more primitive levels of automation to higher, more intelligent, and safer levels. This is the primary way we improve the THEA framework over time.

The upgrade path is as follows:

-   **Level 3: Raw Terminal Commands (`git add .`)**
    -   The "bare metal." Prone to typos and requires memorization.
    -   **Upgrade Trigger:** Any time we find ourselves repeatedly using a raw command for a standard task.

    **⬆️ UPGRADE ⬆️**

-   **Level 2: `Taskfile` Commands (`task build`)**
    -   The "Developer Cockpit." A safe, consistent API for standard actions.
    -   **Upgrade Trigger:** When a task needs to become "smarter" and requires a deeper understanding of the project's state.

    **⬆️ UPGRADE ⬆️**

-   **Level 1: `ContextVibes` Commands (`task context -- ...`)**
    -   The "Intelligent Co-pilot." This tool doesn't just run commands; it understands the code and its context to provide intelligent analysis or perform complex, context-aware actions.

Our goal is to continuously "file" our learnings by upgrading our automation along this path.

## 3. How to Use the Factory

To see a list of all available commands, simply run `task` with no arguments from the project root:

\`\`\`bash
task
\`\`\`

To execute a command, use `task <command>`. For example:

\`\`\`bash
task test
\`\`\`

## 4. The "Blueprint vs. Auditor" Philosophy

A key design philosophy of this factory is the separation of "guides" from "actions," best exemplified by the `provision` and `verify` commands.

*   **`task provision` (The Architect's Blueprint):** A "Guide" task that displays a checklist of what the infrastructure *should* look like.
*   **`task verify` (The Auditor's Report):** A "View" task that programmatically inspects the live infrastructure and reports on its compliance with the blueprint.

This separation keeps the potentially dangerous setup actions in the hands of the user while providing a safe, read-only, automated way to verify that the setup was performed correctly.

## 5. How to Add a New Command

Adding a new command requires following the "Menu / Workflow / Action" pattern. For a detailed walkthrough, please see the `factory/README.md` file.

## 6. Guiding Principle: Self-Contained Actions

A key architectural principle of this factory is that **individual action scripts should be self-contained**. For example, the `release.sh` script contains all the logic it needs to run, including its own internal steps for testing and building. It does **not** call `task test` or `task build`. This prioritizes readability and portability, making it easier to understand a single workflow and eventually migrate it to a standalone CLI tool.
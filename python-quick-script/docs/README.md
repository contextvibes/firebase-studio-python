# The Documentation Library: An Implementation of THEA

## 1. Our Philosophy: A Living Blueprint

Welcome to the documentation library for the **Go Cloud Run Worker** project. This library serves two critical functions:

1.  **Project-Specific Guidance:** It is the single source of truth for all standards, processes, and architectural guides for *this specific application*.
2.  **A Living Implementation of THEA:** This project is a direct implementation of the blueprints defined in the main **[THEA (Tooling & Heuristics for Efficient AI-Development) Framework](https://github.com/contextvibes/THEA)**.

Our goal is to create a feedback loop: we consume proven patterns from THEA, and in turn, the new patterns and improvements developed here can be promoted back to the core framework, benefiting all future projects.

## 2. How to Contribute

All contributions to this library, such as adding a new guide or improving an existing one, must follow a standard procedure to ensure quality and consistency.

-   **[Playbook: Creating New Documentation](./playbooks/creating-new-documentation.md)**

This playbook provides the step-by-step process for authoring, formatting, and submitting new documentation.

---

## 3. Library Structure

The library is organized to separate different types of knowledge, making it easy for contributors to find the information they need.

### Foundational Documents (Root)

These files serve as the primary entry points to the library.

-   **`README.md`**: This file, providing a table of contents and explaining the library's relationship with the THEA framework.
-   **`glossary.md`**: The project's official dictionary, defining key terms and concepts to ensure a consistent vocabulary.
-   **`team-handbook.md`**: The foundational document outlining the project's core philosophy, roles, and collaboration protocols.

### Categorized Subdirectories

These directories group documents by their function.

-   **`/guides`**: Holds practical "how-to" documents and official project standards for specific activities like coding, automation, and styling.
-   **`/lessons-learned`**: An archive of insights and process improvements gained during development. These are excellent candidates for promotion back to the main THEA framework.
-   **`/personas`**: Contains the formal definitions for each specialized AI assistant on the team, detailing their roles and responsibilities.
-   **`/playbooks`**: Contains step-by-step checklists for executing standard project workflows.
-   **`/prompts`**: Stores the master prompts and system instructions that define how the AI assistants should behave and reason.
-   **`/setup`**: Holds one-time setup guides, primarily for configuring the initial cloud infrastructure.
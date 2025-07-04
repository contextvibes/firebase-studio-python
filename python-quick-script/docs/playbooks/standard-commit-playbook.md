# Playbook: FILE-IT-1.0

- **Objective:** To provide a standardized, AI-assisted workflow for committing changes to the repository, ensuring all commits are safe, compliant, and well-documented.
- **Trigger:** This playbook is initiated when the Orchestrator expresses an intent to save work, using phrases like "Let's file this," "Let's commit this," or "Commit these changes."

---

## Process

This playbook outlines the interactive process between THEA (the AI) and the Orchestrator (the user).

| Step | Actor | Action |
| :--- | :--- | :--- |
| **1** | Orchestrator | States the intent to commit work (e.g., "Let's file this"). |
| **2** | THEA | Acknowledges the request and initiates the  playbook. |
| **3** | THEA | Asks the Orchestrator for the primary intent of the commit (e.g., `feat`, `fix`, `docs`, `refactor`, `chore`, `factory`). |
| **4** | Orchestrator | Provides the one-word intent. |
| **5** | THEA | Instructs the Orchestrator to generate the necessary context by running: <br> • `task context -- commit` |
| **6** | Orchestrator | Executes the command and provides the full content of the generated `context_commit.md` file to THEA. |
| **7** | THEA | Analyzes the context and the stated intent to formulate a complete, non-interactive, and compliant commit command. |
| **8** | Orchestrator | Reviews the proposed command for accuracy and executes it in the terminal. |
| **9** | THEA | Confirms the process is complete and asks for the next objective. |


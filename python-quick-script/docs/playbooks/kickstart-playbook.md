# SETUP PLAYBOOK: KICKSTART-1.0

- **Objective:** To have THEA guide the Orchestrator in establishing a consistent and correct initial state for a new session.
- **Process:** THEA issues an instruction for each step. The Orchestrator performs the action in the UI and confirms.

| Step | Action | Details / Source |
| :--- | :--- | :--- |
| **1** | **Set Parameters** | The Orchestrator will set: <br> • Temperature: `0.3` <br> • Tools Enabled: "Grounding with Google Search" |
| **2** | **Load Core Instructions** | The Orchestrator will paste the contents of the following file into the System Instructions panel: <br> • `docs/prompts/aistudio/system-prompt.md` |
| **3** | **Generate Session Context** | The Orchestrator will run the following command in their local terminal to generate the context file: <br> • `task context -- review` |
| **4** | **Provide Session Context** | The Orchestrator will paste the contents of the newly generated file into the main prompt area: <br> • `context_review.md` |
| **5** | **Define Session Goal** | The Orchestrator will append the primary session goal to the end of the context. |
| **6** | **Final Acknowledgment** | THEA will confirm all steps are complete and signal readiness to begin the main task. |

# Playbook: The Contribution Process

This playbook provides the official, step-by-step process for contributing any change (feature, bug fix, documentation update) to this project. Following this process ensures that all contributions are tracked, reviewed, and integrated smoothly.

## Phase 1: Proposing a Change (The "Why")

Before any code is written, the proposed change must be documented and discussed.

1.  **[ ] Create a GitHub Issue:** Open a new issue in the project's GitHub repository.
2.  **[ ] Use the Correct Template:** Select the appropriate issue template (e.g., "Bug Report," "Feature Request").
3.  **[ ] Define the "Why":** Clearly describe the problem you are trying to solve or the value the new feature will provide.
4.  **[ ] Define Acceptance Criteria:** List the specific, testable conditions that must be met for the issue to be considered "Done."
5.  **[ ] Await Triage:** The project maintainers (**Orion** and **Helms**) will review the issue, discuss its priority, and assign it to a milestone. Do not begin work until the issue has been approved.

## Phase 2: Implementation (The "How")

Once an issue is approved, you can begin the implementation by following the standard development workflow.

1.  **[ ] Start a New Task:** Use the `task task-start` command to create a new, correctly named feature branch.
    *   *Example:* `task task-start -- feat TICKET-123 add-user-auth`
2.  **[ ] Develop Using TDD:** Write your code following the project's **[Go Development Guidelines](../guides/go-development-guidelines.md)**. All code must be test-driven.
3.  **[ ] Commit Your Work:** Use the `task commit` command to save your work in small, logical increments.
4.  **[ ] Finish the Task:** Once the implementation is complete and all acceptance criteria are met, use the `task task-finish` command. This will push your branch and open a browser window to create a pull request.

## Phase 3: Review and Merge

1.  **[ ] Create the Pull Request:** In the GitHub UI, write a clear description of your changes, linking to the original GitHub Issue.
2.  **[ ] Request Reviews:** Assign at least one other team member to review your PR.
3.  **[ ] Address Feedback:** Make any necessary changes based on the feedback from the code review.
4.  **[ ] Merge:** Once the PR is approved and all automated checks have passed, merge it into the `main` branch.
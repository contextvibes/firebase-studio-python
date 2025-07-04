# Playbook: Submitting a Feature for Release

This playbook outlines the full lifecycle of a feature, from a local branch to a production release. The `task release` command is an interactive guide that helps you complete this process.

### Phase 1: Preparing Your Feature Branch

This phase is about ensuring your local work is clean, correct, and ready to be merged.

**Checklist:**
1.  **[ ] Sync with `main`:** Ensure your feature branch has the latest changes from the `main` branch. The `task kickoff` command automates this.
2.  **[ ] Run All Tests:** Verify that all unit and integration tests are passing. The `task test` command is used for this.
3.  **[ ] Run Quality Checks:** Ensure the code is well-formatted and passes all linter checks. The `task quality` command handles this.
4.  **[ ] Save All Work:** Commit all your changes with a clear, descriptive message. The `task save` command handles this.
5.  **[ ] Sync with Remote:** Push your final commits to the remote repository. This is handled by `task wrapup`.

### Phase 2: The Pull Request

Once your branch is prepared and pushed, create a Pull Request (PR) on GitHub, targeting the `main` branch.

1.  **[ ] Create the PR:** Use the GitHub UI to open a new pull request.
2.  **[ ] Request Reviews:** Assign at least one other team member to review your code.
3.  **[ ] Wait for CI/CD:** The automated CI/CD pipeline will run all tests and checks on your PR. Ensure it passes.
4.  **[ ] Merge the PR:** Once the PR is approved and all checks pass, merge it into the `main` branch.

### Phase 3: Creating the Release

A release can **only** be created from the `main` branch after your feature has been merged.

1.  **[ ] Checkout `main`:** Run `git checkout main && git pull origin main`.
2.  **[ ] Update `CHANGELOG.md`**: Manually edit the changelog. Move the changes from `[Unreleased]` to a new version section (e.g., `[v1.2.3] - YYYY-MM-DD`).
3.  **[ ] Save the Changelog:** Run `task save -m "docs: update changelog for v1.2.3"`.
4.  **[ ] Run the Release Command:** From the `main` branch, run the automated release command: `task release -- v1.2.3`.

This automated command will tag, build, deploy, and push the final release.
---
id: "guide:managing-github-pat-authentication"
fileExtension: "md"
title: "Guide: Managing GitHub PAT Authentication"
artifactVersion: "1.0.0"
status: "Active"
summary: "The official guide for generating and using a GitHub Personal Access Token (PAT) for secure command-line Git operations, as required by project policy."
usageGuidance:
  - "Follow these steps to create a PAT for authenticating with GitHub."
  - "Use this guide to troubleshoot common PAT authentication errors."
  - "This is the standard procedure for all developers needing CLI access to GitHub repositories."
owner: "Guardian, Scribe"
createdDate: "2025-06-27T00:00:00Z"
lastModifiedDate: "2025-06-27T00:00:00Z"
tags:
  - "guide"
  - "security"
  - "git"
  - "github"
  - "authentication"
  - "pat"
  - "cli"
  - "onboarding"
---
# Guide: Managing GitHub PAT Authentication

## 1. Purpose & Policy

This guide provides the standard procedure for authenticating with GitHub for command-line operations.

**Official Policy:** To ensure the security and integrity of our source code, all personnel must use a **Personal Access Token (PAT)** for any authenticated Git operation performed over HTTPS from the command line (e.g., `git push`, `git pull`). Using your account password for command-line operations is not permitted. This standard enforces best practices for accessing company-owned code.

## 2. Prerequisites

*   A GitHub account with access to the project's repositories.
*   A local machine with Git installed.
*   A locally cloned repository.

## 3. Procedure: Generating and Using a PAT

### 3.1. Generating Your PAT

1.  Log in to your GitHub account.
2.  Navigate to **Settings** > **Developer settings** > **Personal access tokens** > **Tokens (classic)**.
3.  Click **Generate new token** and select **Generate new token (classic)**.
4.  In the "Note" field, provide a descriptive name for the token (e.g., "Work-Laptop-YYYY-MM-DD").
5.  Select an **Expiration** for the token (e.g., 30 or 90 days).
6.  Select the `repo` scope. This is essential to grant access to repositories.
7.  Click **Generate token**.
8.  **Crucial:** Copy the generated token immediately and store it in a secure location (like a password manager). **You will not be able to view the token again after leaving this page.**

### 3.2. Authenticating from the Command Line

When you perform an action that requires authentication (like `git push`), you will be prompted for your credentials:

*   **Username:** Enter your GitHub username.
*   **Password:** Paste your **Personal Access Token (PAT)** here. Do not enter your GitHub password.

### 3.3. Caching Your Token with a Credential Helper (Recommended)

To avoid re-entering your PAT for every operation, you can configure Git to securely store it using a credential helper.

**On macOS (using osxkeychain):**
```bash
git config --global credential.helper osxkeychain
```

**On Windows (using Git Credential Manager):**
*(This is typically enabled by default with Git for Windows.)*
```bash
git config --global credential.helper manager
```

**On Linux (using a plain-text store for simplicity, requires configuration for secure storage):**
```bash
git config --global credential.helper store
```

The next time you authenticate, Git will store your PAT, and subsequent operations will not require a password entry.

## 4. Troubleshooting

*   **"Authentication failed" error:**
    *   Verify that your PAT has not expired.
    *   Confirm that the token has the correct `repo` scope.
    *   Ensure you are using your GitHub username, not your email address, at the username prompt.
*   **"Permission denied" error:**
    *   Confirm that your GitHub account has the necessary permissions (e.g., Write access) for the repository you are trying to push to.

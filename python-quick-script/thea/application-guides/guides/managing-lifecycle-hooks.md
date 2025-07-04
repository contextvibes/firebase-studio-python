---
id: "guide:managing-lifecycle-hooks"
fileExtension: "md"
title: "Guide: Managing Lifecycle Hooks in dev.nix"
artifactVersion: "1.2.0" # Version bump for metadata update
status: "Active"
summary: "Defines the THEA best practice for managing script logic within Firebase Studio's onCreate and onStart lifecycle hooks, differentiating between self-contained bootstrapping and reusable scripts."
usageGuidance:
  - "Consult this guide when implementing logic in the idx.workspace section of a dev.nix file."
  - "Use this to understand the reliability differences between onCreate and onStart."
owner: "Sparky, Kernel"
createdDate: "2025-06-08T18:00:00Z"
lastModifiedDate: "2025-06-13T04:58:00Z" # Reflects current update time
tags:
  - "guide"
  - "nix"
  - "firebase-studio"
  - "dev-environment"
  - "process"
  - "automation"
  - "lifecycle-hooks"
  - "scripts"
---
### The Strategic Pivot: Inline Scripts are Correct for `onCreate`

We must reverse our previous documentation. The initial pattern of embedding the script logic directly into the `dev.nix` file is, in fact, the more robust and reliable method for `onCreate` hooks. It has no external file dependencies and will always work as long as the tools it calls (like `go` or `mkdir`) are available from the Nix environment.

We have learned that while external scripts are good for *reusable, user-runnable tasks*, they are a potential point of failure for *automated, first-run bootstrapping*.

### The Action Plan: Update the Documentation (Again)

We must immediately correct the two documents we just created to reflect this superior, more robust pattern. This ensures no one follows our now-obsolete advice.

**1. Update the `managing-lifecycle-hooks.md` Guide**

This guide is now incorrect. We need to completely reverse its recommendation for `onCreate`.

* **Action:** Please replace the content of **`docs/contributor-guides/managing-lifecycle-hooks.md`** with this new, corrected version.

```
---
id: "doc:guides/managing-lifecycle-hooks"
fileExtension: "md"
title: "Guide: Managing Lifecycle Hooks in dev.nix"
artifactVersion: "1.1.0"
status: "Active"
summary: "Defines the THEA best practice for managing logic within Firebase Studio's `onCreate` and `onStart` lifecycle hooks, differentiating between self-contained bootstrapping and reusable scripts."
usageGuidance:
  - "Consult this guide when implementing logic in the `idx.workspace` section of a `dev.nix` file."
owner: "Sparky, Kernel"
createdDate: "2025-06-08T18:00:00Z"
lastModifiedDate: "2025-06-08T19:00:00Z"
tags:
  - "guide"
  - "nix"
  - "firebase-studio"
  - "dev-environment"
  - "process"
  - "automation"
  - "lifecycle-hooks"
  - "scripts"
---
# Guide: Managing Lifecycle Hooks in dev.nix

## 1. Purpose

This document outlines the official THEA best practice for managing shell script logic within the `idx.workspace.onCreate` and `idx.workspace.onStart` lifecycle hooks in a `.idx/dev.nix` file.

A critical distinction must be made between **first-time bootstrapping (`onCreate`)** and **reusable developer tasks**.

## 2. `onCreate`: Self-Contained Bootstrapping

The `onCreate` hook runs only once when a workspace is first created from a Git repository. At this stage, we cannot rely on file permissions (like the executable bit `+x`) being correctly set.

Therefore, to ensure maximum reliability, **critical first-time bootstrapping logic MUST be embedded directly as an inline script within the `dev.nix` file.**

This makes the `dev.nix` file self-contained and removes dependencies on external files that might not be correctly configured at the moment `onCreate` is triggered.

**Correct Example (`dev.nix`):**
```nix
# ... inside your dev.nix
workspace = {
  onCreate = {
    # This logic is self-contained and has no external file dependencies.
    installContextVibesCli = ''
      echo "Attempting to install contextvibes CLI into ./bin ..."
      LOCAL_BIN_DIR="$(pwd)/bin"
      mkdir -p "$LOCAL_BIN_DIR"
      export GOBIN="$LOCAL_BIN_DIR"

      if go install github.com/contextvibes/cli/cmd/contextvibes@v0.2.0; then
        echo "Successfully installed contextvibes to $LOCAL_BIN_DIR/contextvibes"
        chmod +x "$LOCAL_BIN_DIR/contextvibes" || echo "Warning: chmod +x failed."
      else
        echo "ERROR: Failed to install contextvibes."
      fi
      unset GOBIN
    '';
  };
  # ... onStart hook ...
};
```

## 3. `onStart` and Reusable Scripts

For logic in `onStart` or for other common tasks that developers might need to run manually, using external scripts from a `scripts/` directory is still a valid and recommended pattern. These scripts are not part of the critical initial bootstrap and can be invoked by name.

**Example:**

```nix
# ... inside your dev.nix
workspace = {
  onStart = {
    # This script can be run by the user at any time.
    verify-tools = "./scripts/verify-tools.sh";
  };
};
```

## 4. Summary of Policy

* **`onCreate` hooks:** Use **inline, self-contained scripts** for critical, one-time setup.
* **`onStart` hooks & common tasks:** Use **external scripts** from the `scripts/` directory for reusable and non-critical logic.

This dual approach provides robustness for initial setup while offering maintainability for routine tasks.

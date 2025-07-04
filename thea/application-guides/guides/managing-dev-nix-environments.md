---
id: "guide:managing-dev-nix-environments"
fileExtension: "md"
title: "Guide: Managing dev.nix in Firebase Studio"
artifactVersion: "1.5.0" # Version bump for metadata update
status: "Active"
summary: "The official guide and best practices for creating, reviewing, and maintaining the .idx/dev.nix file for THEA project development environments in Firebase Studio."
usageGuidance:
  - "This is the single source of truth for managing a project's dev.nix file."
  - "Use this as the standard for reviewing Pull Requests that modify the development environment."
  - "Consult this to find the official Nix package search website and the THEA channel policy."
owner: "Sparky"
createdDate: "2025-06-08T14:30:00Z"
lastModifiedDate: "2025-06-13T04:57:00Z" # Reflects current update time
tags:
  - "guide"
  - "nix"
  - "firebase-studio"
  - "dev-environment"
  - "process"
  - "sparky"
  - "contributor-guide"
  - "policy"
---
# Guide: Managing dev.nix in Firebase Studio

## 1. Purpose

This document provides the standard process and best practices for managing the `.idx/dev.nix` file within the THEA project. A consistent and well-maintained development environment is crucial for developer productivity and reducing configuration-related issues. All projects must adhere to these policies.

## 2. Core Policies & Principles

- **Single Source of Truth:** The `.idx/dev.nix` file is the single, authoritative source of truth for the development environment within Firebase Studio.
- **Reproducibility:** The environment must be fully reproducible from this file.
- **Minimalism:** Only include packages and tools that are essential for the project.
- **Explicitness & Stability:** THEA's official channel is **`stable-25.05`**. For language toolchains, pin to a specific version where possible (e.g., `pkgs.go_1_22`) to prevent unexpected updates.

## 3. The THEA Foundational Template

All new THEA projects SHOULD start with a `.idx/dev.nix` file based on the following template. It is structured for clarity, maintainability, and adherence to our learned best practices.

```nix
# .idx/dev.nix
# This is the single source of truth for the THEA development environment in Firebase Studio.
{ pkgs, ... }: {
  # Specifies the Nixpkgs channel for stability and reproducibility.
  channel = "stable-25.05";

  # Packages and tools available in the development environment.
  # Policy: Group packages by function and sort alphabetically within each group.
  # Use the 'with pkgs;' statement for improved readability.
  packages = with pkgs; [
    # --- Universal THEA Tools ---
    alejandra # The official Nix code formatter for consistency
    jq # Command-line JSON processor
    nodePackages.markdownlint-cli # For Markdown documentation quality
    statix # A linter for the Nix language

    # --- Core Development Workflow ---
    git
    # ... other core tools like go-task, etc.
  ];

  # Global environment variables for the workspace.
  env = {};

  # Firebase Studio specific configurations.
  idx = {
    # VS Code extensions to install from https://open-vsx.org/
    extensions = [
      # --- Universal THEA Extensions ---
      "davidanson.vscode-markdownlint"
      "kamadorueda.alejandra"
    ];

    # See the "Managing Lifecycle Hooks" guide for full details on these hooks.
    workspace = {
      # Use an inline script for critical, one-time bootstrapping.
      onCreate = {
        # example-bootstrap = ''
        #   echo "Bootstrapping environment..."
        #   # Add self-contained bootstrap logic here.
        # '';
      };
      
      # Use for verification or recurring tasks.
      onStart = {};
    };
  };
}
```

## 4. Universal Workflow for Adding a Package

1. **Find the Package:** Go to the official Nix Packages search: **[search.nixos.org](https://search.nixos.org/packages)**.
2. **Identify Attribute Name:** Search for your tool. The correct name to use is the "attribute name" (e.g., `nodejs_22`, `python311`).
3. **Add to `dev.nix`:** Add the package to the appropriate functional group in the `packages` list, keeping the group alphabetically sorted.
4. **Rebuild Environment:** Save the `.idx/dev.nix` file. Firebase Studio will prompt you to rebuild the environment. Click "Rebuild".
5. **Verify:** Open a new terminal and verify the tool is installed using `which <tool-command>` or `<tool-command> --version`.

## 5. Managing Lifecycle Hooks (`onCreate` & `onStart`)

A crucial distinction exists between these two hooks based on reliability during initial workspace creation.

For the complete, official policy and implementation patterns, refer to:

- **[Guide: Managing Lifecycle Hooks in dev.nix](./managing-lifecycle-hooks.md)**

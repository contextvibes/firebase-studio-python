# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

*   **Multi-Language Support:** The repository now supports both Go and Python templates.
*   **Python Template:** Added a new `python-quick-script` template for bootstrapping simple Python applications.
*   **Language-Aware Automation:** The `factory` scripts (`test`, `analyze`, etc.) have been updated to automatically detect the project language (Go or Python) and use the appropriate tools.
*   **Enhanced Dev Environment:** The `.idx/dev.nix` file has been updated to include Python, pytest, and flake8.
*   **Improved `.gitignore`:** The `.gitignore` file has been updated with comprehensive patterns for both Go and Python projects.

### Changed

*   **Generalized AI Rules:** The `.idx/airules.md` has been refactored to be language-agnostic, improving guidance for a multi-language context.
*   **Updated Template Manifest:** The `idx-template.json` now includes all available Go and Python templates.

## [0.1.0] - 2025-06-28

### Added

*   **Initial Public Release:** First version of the Go Starter Templates for Firebase Studio.
*   **Templates:**
    *   `cloud-run-api`: A "Hello World" API server for Google Cloud Run.
    *   `cli-tool`: A starter template for a command-line application.
*   **Automation Factory:** A comprehensive automation framework using `Taskfile` to manage building, testing, analyzing, and context generation.
*   **Documentation Library:**
    *   Guides on using the automation `factory`.
    *   Detailed documentation on the THEA (Technologically-Enhanced Agile) development methodology.
*   **Development Environment:**
    *   Declarative developer environment for Firebase Studio using Nix (`.idx/dev.nix`).
*   **Project Governance:**
    *   `CONTRIBUTING.md` with guidelines for community contributions.
    *   MIT `LICENSE`.
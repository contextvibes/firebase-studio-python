# User Guide: Using ContextVibes CLI for AI Context Generation

**Version:** 1.0
**Date:** 2025-06-06
**Primary Author (Conceptual):** `Scribe`
**Technical Contributor (Conceptual):** `Kernel`
**Reviewed By (Conceptual):** `Athena`, `Logos`, `Canon`

## 1. Introduction

The `ContextVibes CLI` is a powerful tool designed to streamline development workflows, including enhancing interactions with AI assistants. A key capability of the CLI is its ability to gather and structure project information into a format that is highly suitable for providing context to Large Language Models (LLMs) and other AI tools. This guide details the primary `ContextVibes CLI` commands used for generating and managing this AI-ready context.

Understanding these commands will help you provide precise and relevant information to your AI assistant, leading to more accurate, efficient, and contextually aware AI-driven development.

## 2. Core Commands for AI Context

The following commands are central to generating context for AI:

### 2.1. `contextvibes describe` - Comprehensive Project Snapshot

**Purpose:**
The `describe` command is the primary tool for generating a comprehensive snapshot of the current project's state. It intelligently gathers various pieces of information—including a user-provided prompt, environment details, Git status, project structure, and the content of relevant files—and compiles them into a single Markdown file (default: `contextvibes.md`). This file is specifically formatted to be easily digestible by AI assistants.

A key feature of `describe` is its intelligent filtering: it respects rules in `.gitignore` and `.aiexclude` files, and adheres to file size limits. This ensures that the context provided to the AI is relevant and doesn't include unnecessary or excessively large files.

**Syntax:**

```bash
contextvibes describe [-o <output_file>] [flags]
```

* Running `contextvibes describe` without options will prompt for user input (a query or goal for the AI) and save the context to `contextvibes.md`.
* `-o <output_file>` or `--output <output_file>`: Allows you to specify a custom path and filename for the output Markdown file. This is useful for saving multiple context snapshots or avoiding overwrites.

**Typical Output (`contextvibes.md` or custom file):**
The generated Markdown file typically includes:

1. **User Prompt:** The prompt/query you provided when running the command (if run interactively).
2. **Collaboration Notes:** A standard header provided by the CLI.
3. **Environment Context:** OS type, key tool versions (Go, git, gcloud), and relevant environment variables.
4. **Git Status (Summary):** A detailed overview of local changes (modified, staged, untracked files).
5. **Project Structure (Top Levels):** A directory tree layout.
6. **Relevant Code Files Follow:** Content of key project files, filtered by ignore rules and size limits.

**Use Cases for LLMs:**

* Providing broad context for general project questions or architectural discussions.
* Generating new features or modules based on existing project structure and code patterns.
* Assisting with debugging issues that may span multiple files or involve environmental factors.
* Onboarding new developers (human or AI) to the project by providing a quick overview.
* Drafting initial project summaries, documentation, or reports.

**Important Considerations:**

* **Intelligent Filtering:** Always remember that `describe` filters content. If a file seems missing from the context, check your `.gitignore` and `.aiexclude` files.
* **Interactive Prompt:** Running `describe` without the global `--yes` flag allows you to provide a natural language prompt that frames the context for the AI, which is highly recommended.

### 2.2. `contextvibes diff` - Focused Change Context

**Purpose:**
The `diff` command generates a `contextvibes.md` file (by default, overwriting any existing one) that specifically summarizes pending changes in your Git repository. This includes staged changes, unstaged changes, and untracked files. It's designed to provide a more targeted context to an AI when your task revolves around recent modifications.

**Syntax:**

```bash
contextvibes diff [flags]
```

* There are no command-specific flags for `diff` beyond the global flags.

**Output (`contextvibes.md`):**

* The `contextvibes.md` file will be **overwritten**.
* The content will primarily be a Markdown-formatted representation of the `git diff` output.
* It will also likely summarize the names of files that are staged, unstaged, or untracked.

**Use Cases for LLMs:**

* Assisting with code reviews by providing only the changed code.
* Generating commit messages based on the specific changes made.
* Explaining the potential impact or purpose of recent modifications.
* Helping to understand or resolve merge conflicts by clearly showing the diff.

**Important Considerations:**

* **CRITICAL: Overwrites `contextvibes.md`!** If you have a comprehensive project context generated by `describe` in `contextvibes.md`, running `diff` will replace it.
* **Recommendation:** If you need to preserve both a full project snapshot and a diff context, use the `-o <custom_file>` option with `contextvibes describe` before running `contextvibes diff`.
* To return to a full project context in `contextvibes.md` after running `diff`, you must execute `contextvibes describe` again.

### 2.3. `contextvibes codemod` - Applying Structured Code Changes

**Purpose (Indirect AI Context):**
The `codemod` command doesn't generate broad project context *for* an AI to read. Instead, it *applies* programmatic code modifications or deletions based on a structured JSON script. Its relevance to AI context is that an **LLM can be tasked with *generating* this `codemod.json` script** based on a natural language refactoring request. The JSON script itself becomes the "context" or instruction set that the AI produces for `ContextVibes CLI` to execute.

**Syntax:**

```bash
contextvibes codemod [--script <file.json>] [flags]
```

* `contextvibes codemod`: Looks for a `codemod.json` file in the current directory.
* `--script <file.json>` or `-s <file.json>`: Specifies the path to the JSON codemod script.

**Input JSON Script Structure:**
The script is an array of objects, where each object defines:

* `"file_path"`: The path to the file to be modified or deleted.
* `"operations"`: An array of operation objects for that file.
  * **Supported Operation Types:**
    * `"regex_replace"`: Requires `"find_regex": "..."`, `"replace_with": "..."`.
    * `"delete_file"`: No further fields needed.

**Use Cases for LLMs (AI generates the JSON script):**

* Performing automated refactoring tasks (e.g., "AI, rename all occurrences of `OldClass` to `NewClass` in module X. Provide the `codemod.json` script.").
* Automated cleanup (e.g., "AI, remove all `*.log` files from the `tmp/` directory. Provide the `codemod.json` script.").

**Important Considerations:**

* **AI as Generator:** Clearly understand that the AI's role here is to *produce* the JSON script that `codemod` then consumes.
* **Script Accuracy:** The accuracy of the `codemod` operation depends entirely on the correctness of the JSON script generated by the AI. Careful review of the AI-generated script is advised before execution.
* **Confirmation:** `codemod` requires confirmation before applying changes, unless the global `--yes` (`-y`) flag is used.

### 2.4. `contextvibes status` - Minimal Git Status Context

**Purpose:**
The `status` command displays a concise summary of the Git working tree status, equivalent to `git status --short`. This is useful for providing an AI with a very quick, high-level understanding of modified, staged, or untracked files.

**Syntax:**

```bash
contextvibes status [flags]
```

* There are no command-specific flags for `status` beyond the global flags.

**Output:**

* Output is directly to the terminal.
* The format matches `git status --short` (e.g., `M README.md`, `?? new_file.txt`).
* **This command does not write to `contextvibes.md`**.

**Use Cases for LLMs:**

* Quick check before suggesting Git operations (e.g., "AI, are there any uncommitted changes?").
* As a very brief initial piece of context before potentially running a more detailed `describe` or `diff`.

**Important Considerations:**

* **Conciseness:** Provides only file status, not content or detailed diffs.
* **Terminal Output:** Does not update or create `contextvibes.md`.

## 3. Global Flags Affecting Context & AI Interaction

The following global flags can be used with most `ContextVibes CLI` commands and are relevant when using the CLI for AI purposes:

* `--ai-log-file string`: Specifies a path for a detailed JSON log of CLI operations (default: `contextvibes_ai_trace.log`). This can be invaluable for debugging how the CLI is gathering context or interacting, especially if you suspect issues in the AI's understanding based on the provided context.
* `--log-level-ai string`: Controls the verbosity of the AI trace log (options: `debug`, `info`, `warn`, `error`; default: `debug`).
* `-y, --yes`: Assumes 'yes' to all confirmation prompts (e.g., in `codemod`, or the initial prompt in `describe`). This is essential for scripting CLI commands or when an AI is orchestrating `ContextVibes CLI` operations non-interactively.

## 4. Best Practices Summary

* Use `contextvibes describe` for comprehensive project context.
* Use `contextvibes diff` for targeted context about recent changes (be mindful of overwrites).
* Consider `contextvibes codemod` in workflows where an AI generates structured refactoring scripts.
* Use `contextvibes status` for quick, minimal Git status checks.
* Leverage the `-o` option with `describe` to save different context snapshots.
* Utilize global flags like `--yes` for automation and `--ai-log-file` for debugging.

By mastering these commands, you can significantly improve the quality of context provided to your AI assistants, leading to more effective and efficient AI-assisted development within the THEA framework.

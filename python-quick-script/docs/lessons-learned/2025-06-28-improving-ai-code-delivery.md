---
title: "Lesson: Ensuring Raw Code Blocks are Copyable in UI"
date: "2025-06-28"
status: "Completed"
tags: ["lesson", "ai-interaction", "workflow", "ui"]
---

### 1. Context

We are engaged in a collaborative session where the AI assistant generates `bash` commands to create or update project files. These commands often use multi-line `heredoc` syntax (e.g., `cat <<'EOF' > ...`) to pipe complex Markdown or code into a file.

### 2. Problem / Friction Point

The user interface where we are collaborating automatically renders any Markdown it detects. When the AI provided a `bash` command that contained Markdown content inside the `heredoc`, the UI rendered the *inner* Markdown.

This made it impossible for the user (the Orchestrator) to copy the complete, raw `bash` command in a single, error-free step. The rendered text was not valid shell script.

### 3. Solution / Workaround

The solution is for the AI to wrap the **entire** `bash` command, including the `(cat <<'EOF' ... EOF)` block, inside a single, top-level Markdown code fence (```bash ... ```).

This forces the UI to treat the whole block as pre-formatted text and prevents it from rendering the inner content. This allows the user to reliably copy the complete, valid command with a single click.

### 4. Suggestion for THEA Framework

This interaction pattern should be adopted as a standard for all AI personas when delivering file content or complex, multi-line scripts.

The core `airules.md` or the `team-handbook.md` should be updated to include a rule under the "AI-Orchestrator Interaction Protocol" or "Output Formatting" section.

**Proposed Rule:** "When providing a shell command that pipes or writes multi-line content (especially Markdown or code), the *entire command block* must be enclosed in a `bash` fenced code block to prevent the UI from rendering the inner content."

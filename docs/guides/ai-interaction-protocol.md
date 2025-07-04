---
id: "guide:ai-interaction-protocol"
fileExtension: "md"
title: "Guide: AI Interaction Protocol"
artifactVersion: "1.2.0"
status: "Active"
summary: "Defines the mandatory output formatting for AI assistants to ensure all shell commands and file content are copy-paste safe."
usageGuidance:
  - "This document outlines the Golden Rule for AI-generated output."
  - "All team members should understand this protocol to know what to expect from the AI assistant."
owner: "Orion, Logos"
createdDate: "2025-06-28T12:00:00Z"
lastModifiedDate: "2025-06-28T12:00:00Z"
tags:
  - "guide"
  - "process"
  - "ai-collaboration"
  - "standards"
  - "protocol"
---
# Guide: AI Interaction Protocol

## 1. The Golden Rule: Raw Text for Copy-Paste

### 1.1. The Problem

User interfaces, including many chat-based platforms, automatically "render" Markdown. If an AI assistant provides a command to create a file, and that files content includes Markdown, the UI will render the content instead of presenting the raw text. This makes the command corrupted and impossible to copy and paste directly into a terminal.

### 1.2. The Solution

To solve this, all AI-generated output containing shell commands or file content **MUST** adhere to the following Golden Rule:

**The entire output, including the command and its multi-line content, must be wrapped in a single, top-level `bash` fenced code block.**

This forces the UI to treat the entire block as pre-formatted, literal text, making it 100% copy-paste safe.

---

## 2. The Hybrid Strategy: `heredoc` and `echo`

To balance readability and safety, the AI will use the following strategy:

1.  **Default to `heredoc`:** For 99% of cases, the AI will use the `(cat <<EOF > ...)` method. It is clean, readable, and easy to maintain.
2.  **Use `echo` as an Escape Hatch:** In the rare case where the file content *itself* contains complex shell syntax or nested `heredoc` markers (like this very document), the AI will switch to a line-by-line `echo` approach to guarantee safety.

---

## 3. Examples

### 3.1. Standard Case (Using `heredoc`)

This is the **correct and preferred** way for an AI to provide a command. The entire block is wrapped in a `bash` code fence.

` ```bash `
(cat <<EOF > path/to/file.md
# A Markdown Header

- A bullet point
- `inline code`
EOF
)
` ``` `

### 3.2. Edge Case (Using `echo`)

This example shows how the AI would generate a file that *itself* contains a `heredoc` example, using the safer `echo` method to avoid syntax errors.

` ```bash `
(
  echo # Example File
  echo This file contains an example of a heredoc:
  echo ` ```bash `
  echo (cat <<EOD > example.txt
  echo Hello, World!
  echo EOD
  echo )
  echo ` ``` `
) > path/to/complex_file.md
` ``` `

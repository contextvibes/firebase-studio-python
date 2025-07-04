# Guide: Code Commenting and Finalization Standard

## 1. Purpose

This document provides the definitive standard for how all Go code in this project must be commented. It also defines the mandatory "Finalization Pass" that must be performed to clean up development-phase comments before a feature is considered complete.

This guide applies to both human and AI developers. Its purpose is to ensure our codebase is clean, maintainable, and that its comments provide high-signal, high-value context to future developers.

## 2. The Golden Rule: Comment the "Why," Not the "What"

Our core philosophy is that **code should be self-documenting**. Well-written, idiomatic Go should clearly express *what* it is doing. Comments serve a different, more important purpose: to explain **why** the code is doing it.

-   **Do Not** write comments that simply restate the code:
    ```go
    // BAD: This comment is redundant and adds no value.
    // Increment i by 1.
    i++
    ```

-   **Do** write comments that provide crucial context that *cannot* be inferred from the code itself:
    ```go
    // GOOD: This comment explains the non-obvious business reason for this check.
    //
    // Check for a negative balance. This is a temporary workaround for the upstream
    // payment processor bug (see TICKET-123), which can briefly return a negative
    // value before the transaction is finalized.
    if balance < 0 {
        // ...
    }
    ```

## 3. The Two Phases of Generation

Every piece of code exists in one of two states: **Iterative Development (WIP)** or **Finalized**. Each state has a different set of commenting rules.

### Phase 1: Iterative Development (WIP)

This is the collaborative phase where we are actively building and refactoring. During this phase, it is critical to be explicit about the reasoning behind changes.

All development-phase comments **MUST** use one of the following prefixes. This creates a clear, machine-readable "diff" of our thinking.

*   `# REASON:` Use this to explain the high-level strategic thinking behind a change.
*   `# FIX:` Use this when correcting an error or bug.
*   `# ADDED:` Use this when introducing a new, self-contained block of code.
*   `# REFACTOR:` Use this when improving code structure without changing its functionality.
*   `# NOTE:` Use this for general observations or suggestions for future improvement.
*   `# TODO:` Use this to mark known, incomplete implementations that must be addressed.

### Phase 2: The Finalization Pass

This phase occurs when the feature is functionally complete and correct. Before the code can be merged, the author **MUST** perform a "Finalization Pass."

**Directive:**
1.  **Remove ALL** development-phase comment markers (`# REASON:`, `# FIX:`, `# ADDED:`, etc.).
2.  **Elevate or Delete:** For each comment, make a decision:
    *   If the comment explains a high-level "why" that is not obvious from the code, **rewrite it** as a clean, high-level `//` or `/* ... */` block comment.
    *   If the comment is no longer relevant or explains something that is now obvious, **delete it**.
3.  The only comments remaining must be those that provide long-term value to future developers, as defined by the Golden Rule.

### 4. Example of the Full Lifecycle

#### Before (During Iterative Development)
```go
// REASON: The original loop was causing a memory leak. This new implementation
// uses a channel to process items concurrently while limiting goroutines.
// TODO: The buffer size of 20 is a magic number; this should be configurable.
ch := make(chan *Item, 20)
```

#### After (Finalized Code)
```go
// Using a buffered channel allows us to limit the number of concurrent workers
// processing items, preventing a resource leak that occurred with the previous
// unbounded goroutine implementation.
ch := make(chan *Item, 20) // TODO: The buffer size should be made configurable.
```

By adhering to this standard, we ensure that our final codebase is clean and that its comments are consistently valuable.
EOF

echo "✅ The new guide 'docs/guides/code-commenting-standard.md' has been created."

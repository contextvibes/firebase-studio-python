#!/bin/bash
#
# WHAT: A master script for generating context for various development goals.
#       It supports multiple modes for creating targeted reports for an AI
#       assistant (e.g., for commits, PRs) and for exporting different
#       layers of the project architecture (Product, Factory, Library).
#
# WHY:  Provides a single, maintainable entry point (`task context`) for all
#       context-related tasks, with a user-friendly interactive menu and a
#       parameterized interface for automation.

set -euo pipefail

# --- Configuration & Setup ---

# WHAT: Programmatically finds the absolute path to the project's root directory.
# WHY:  This makes all subsequent file paths robust and independent of the
#       directory from which the script is executed.
GIT_ROOT=$(git rev-parse --show-toplevel)
readonly GIT_ROOT

# WHAT: Imports the single source of truth for all shared helper functions.
# WHY:  Promotes code reuse and keeps this script's logic focused on its main task.
#       All generic helpers (like `is_text_file`) live in this central library.
# shellcheck source=./_automation_helpers.sh
source "$(dirname "$0")/_automation_helpers.sh"


# ==============================================================================
#                             SHARED EXPORT HELPER
# ==============================================================================
# WHAT: A reusable function that finds all tracked, text-based files in a
#       given set of paths and appends their content to a report file.
# WHY:  This helper prevents code duplication across all the different
#       "export-*" actions, ensuring a consistent output format.
#
# USAGE: export_book "Output Filename" "Book Title" "path1" "path2" ...
#
export_book() {
    local output_file="$1"
    local title="$2"
    shift 2
    local paths=("$@")

    { echo ""; echo "---"; echo "## Book: ${title}"; echo ""; } >> "$output_file"

    # Use `git ls-files` to get a definitive list of all files tracked by Git.
    git -C "$GIT_ROOT" ls-files -- "${paths[@]}" | while IFS= read -r file; do
        [ -z "$file" ] && continue
        local full_path="$GIT_ROOT/$file"

        # A safety check to avoid printing binary files to the context.
        if ! is_text_file "$full_path"; then
            echo "--> Skipping non-text/binary file: $file"
            continue
        fi

        # Append the file's content, wrapped in a formatted block.
        {
            echo ""
            echo "======== FILE: ${file} ========"
            echo "\`\`\`${file##*.}"
            cat "$full_path"
            echo "\`\`\`"
            echo "======== END FILE: ${file} ========"
        } >> "$output_file"
    done
}


# ==============================================================================
#                                SCRIPT ACTIONS
# ==============================================================================

# WHAT: Calls the dedicated helper script to generate the AI Studio kickstart playbook.
# WHY:  Delegates complex logic to a dedicated script, keeping this main script clean.
generate_aistudio_kickstart_context() {
    "$GIT_ROOT/factory/scripts/context_helpers/aistudio_kickstart.sh"
}


# WHAT: Creates a context file with git status and a diff of all uncommitted changes.
# WHY:  Provides an AI with the precise information needed to draft a high-quality commit message.
generate_commit_context() {
    local output_file="$GIT_ROOT/context_commit.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/generate-commit-message.md"
    
    echo "--> Generating context for commit message..."
    
    generate_report_header "$output_file" "$prompt_file" "Generate Conventional Commit Command" "..."

    {
        echo ""
        echo "## Git Status"
        echo "\`\`\`"
        git status
        echo "\`\`\`"
        echo ""
        echo "---"
        echo "## Diff of All Uncommitted Changes"
        echo "\`\`\`diff"
        git diff --staged
        git diff
        echo "\`\`\`"
    } >> "$output_file"

    echo "✅ Commit context generated. File: '$output_file'"
}

# WHAT: Creates a context file with the commit history and a full diff of the current branch against main.
# WHY:  Gives an AI a complete picture of all changes in a feature branch, allowing it to write a thorough PR description.
generate_pr_context() {
    local output_file="$GIT_ROOT/context_pr.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/generate-pr-description.md"
    local main_branch="main"

    echo "--> Generating context for Pull Request description..."

    if ! git diff --quiet --exit-code; then
        gum style --foreground 212 "⚠️  Warning: You have uncommitted changes. They will not be included in the PR context."
    fi

    local merge_base
    merge_base=$(git merge-base "$main_branch" HEAD)

    generate_report_header "$output_file" "$prompt_file" "Generate Pull Request Description" "..."

    {
        echo ""
        echo "## Commit History on This Branch"
        echo "\`\`\`"
        git log --pretty=format:'%h %s (%an, %cr)' "$merge_base"..HEAD
        echo "\`\`\`"
    } >> "$output_file"

    {
        echo ""
        echo "---"
        echo "## Full Diff for Branch (vs. $main_branch)"
        echo "\`\`\`diff"
        git diff "$merge_base"..HEAD
        echo "\`\`\`"
    } >> "$output_file"

    echo "✅ Pull Request context report saved to '$output_file'."
}

# WHAT: Creates a comprehensive report of all changes on the current branch (committed and uncommitted).
# WHY:  Provides an AI with a full snapshot of the branch's state for verification or review tasks.
generate_review_context() {
    local output_file="$GIT_ROOT/context_review.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/review-changes.md"
    local main_branch="main"
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    echo "--> Generating comprehensive review context..."

    generate_report_header "$output_file" "$prompt_file" "Verification of Changes" "..."

    {
        echo "# Verification Report"
        echo ""
        echo "**Branch:** \`$current_branch\`"
        echo "**Generated:** $(date -u)"
        echo "---"
        echo ""
        echo "## 1. Uncommitted Local Changes"
        echo "\`\`\`"
        if [[ -z $(git status --porcelain) ]]; then
            echo "No uncommitted local changes."
        else
            git status
        fi
        echo "\`\`\`"
        echo ""
        echo "---"
        echo "## 2. Aggregated Diff of All Changes vs \`$main_branch\`"
        echo "\`\`\`diff"
        
        local merge_base
        merge_base=$(git merge-base "$main_branch" HEAD)
        
        git diff "$merge_base"..HEAD
        git diff HEAD
        
        echo "\`\`\`"
    } >> "$output_file"

    echo "✅ Review context report generated. Saved to '$output_file'."
}

# WHAT: Exports a comprehensive snapshot of the entire project.
# WHY:  Provides a complete context file for high-level AI analysis, onboarding, or architectural review.
export_all_project() {
    local output_file="$GIT_ROOT/contextvibes_export_project.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-project-context.md"

    echo "--> Generating full project export..."

    generate_report_header "$output_file" "$prompt_file" "Full Project Context Analysis" "..."

    # This export is organized by the "Product, Library, Factory" model.
    export_book "$output_file" "Project Root & Configuration" ".gitignore" ".dockerignore" ".aiexclude" ".env.example" "CHANGELOG.md" "CONTRIBUTING.md" "LICENSE" ".markdownlint.json" ".markdownlintignore"
    export_book "$output_file" "The Product (Application Source Code)" "src/"
    export_book "$output_file" "The Factory (Automation Framework)" "Taskfile.yml" "factory/" ".idx/" ".vscode/"
    export_book "$output_file" "The Library (Project Documentation)" "docs/"

    echo "✅ Full project export complete. Report saved to '$output_file'."
}

# WHAT: Exports only the application source code.
# WHY:  Creates a focused context file for tasks related to analyzing the main application.
export_code_only() {
    local output_file="$GIT_ROOT/context_export_code.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-code-context.md"
    
    echo "--> Exporting application code only..."

    generate_report_header "$output_file" "$prompt_file" "Application Code Analysis" "..."
    export_book "$output_file" "The Product (Application Source Code)" "src/"
    echo "✅ Code export complete. Report saved to '$output_file'."
}

# WHAT: Exports only the project documentation.
# WHY:  Creates a focused context file for tasks related to updating documentation.
export_docs_only() {
    local output_file="$GIT_ROOT/context_export_docs.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-docs-context.md"
    
    echo "--> Exporting all documentation..."

    generate_report_header "$output_file" "$prompt_file" "Documentation & Guidance Analysis" "..."
    export_book "$output_file" "The Library (Project Documentation)" "docs/" "README.md" "LICENSE" "CONTRIBUTING.md"
    echo "✅ Complete documentation export complete. Report saved to '$output_file'."
}

# WHAT: Exports only the automation framework.
# WHY:  Creates a focused context file for tasks related to improving the automation tooling.
export_automation_only() {
    local output_file="$GIT_ROOT/context_export_automation.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-automation-context.md"
    
    echo "--> Exporting automation framework only..."
    
    generate_report_header "$output_file" "$prompt_file" "Automation Framework Analysis" "..."
    export_book "$output_file" "The Factory (Automation Framework)" "Taskfile.yml" "factory/" ".idx/" ".vscode/"
    echo "✅ Automation export complete. Report saved to '$output_file'."
}


# ==============================================================================
#                                MAIN CONTROLLER
# ==============================================================================
# WHAT: Displays an interactive menu for the user to select an action.
# WHY:  Provides a user-friendly, discoverable interface for the script's capabilities.
show_menu() {
    gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "CONTEXT GENERATOR"
    echo "Please select the type of context you want to generate:"

    local CHOICE
    CHOICE=$(gum choose \
        "For an AI Studio Kickstart" \
        "For a Commit Message" \
        "For a Pull Request Description" \
        "For a Local Code Review" \
        "Export: Full Project (All)" \
        "Export: Code Only" \
        "Export: Documentation Only" \
        "Export: Automation Only" \
        "Quit")

    case "$CHOICE" in
        "For an AI Studio Kickstart")   generate_aistudio_kickstart_context ;;
        "For a Commit Message")         generate_commit_context ;;
        "For a Pull Request Description") generate_pr_context ;;
        "For a Local Code Review")      generate_review_context ;;
        "Export: Full Project (All)")   export_all_project ;;
        "Export: Code Only")            export_code_only ;;
        "Export: Documentation Only")     export_docs_only ;;
        "Export: Automation Only")        export_automation_only ;;
        "Quit")                         echo "Aborted."; exit 0 ;;
        *)                              echo "No selection. Aborting."; exit 1 ;;
    esac
}

# WHAT: The main router for the script. It runs a specific function based on
#       the first command-line argument.
# WHY:  This allows the script to be used both interactively (no arguments)
#       and non-interactively in automated workflows (`task context -- pr`).
readonly MODE="${1:-menu}"

case "$MODE" in
    menu)               show_menu ;;
    aistudio-kickstart) generate_aistudio_kickstart_context ;;
    commit)             generate_commit_context ;;
    pr)                 generate_pr_context ;;
    review)             generate_review_context ;;
    export-all)         export_all_project ;;
    export-code)        export_code_only ;;
    export-docs)        export_docs_only ;;
    export-automation)  export_automation_only ;;
    *)
        echo "❌ ERROR: Invalid mode '$MODE' provided." >&2
        echo "   Valid modes are: aistudio-kickstart, commit, pr, review, export-all, export-code, export-docs, export-automation" >&2
        exit 1
        ;;
esac
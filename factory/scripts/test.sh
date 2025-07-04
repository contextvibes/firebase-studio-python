#!/bin/bash
#
# WHAT: An intelligent script for running tests. It supports an interactive
#       menu for developers and parameterized flags for automation pipelines.
#
# WHY:  Provides a single, consistent entry point for all testing needs,
#       preventing logic duplication while supporting both human and machine users.

set -e

# --- Helper Functions for Test Execution ---

run_unit_tests() {
    local module_files
    module_files=$(find . -name "go.mod" -not -path "./.idx/*")
    if [ -z "$module_files" ]; then return; fi

    echo "$module_files" | while read -r mod_file; do
        local module_dir
        module_dir=$(dirname "$mod_file")
        # FIX: Correctly quote the string for gum style.
        gum style --bold --padding "0 1" -- "Running unit tests for module: $module_dir"
        (
            cd "$module_dir"
            go test -v -cover -coverprofile=coverage.out ./...
        )
    done
}

run_race_tests() {
    local module_files
    module_files=$(find . -name "go.mod" -not -path "./.idx/*")
    if [ -z "$module_files" ]; then return; fi

    echo "$module_files" | while read -r mod_file; do
        local module_dir
        module_dir=$(dirname "$mod_file")
        # FIX: Correctly quote the string for gum style.
        gum style --bold --padding "0 1" -- "Running unit tests with race detector for module: $module_dir"
        (
            cd "$module_dir"
            CGO_ENABLED=1 go test -v -race -cover -coverprofile=coverage.out ./...
        )
    done
}

run_integration_tests() {
    gum style --bold --foreground 196 "WARNING: This will run a fresh deployment before starting the tests."
    if ! gum confirm "This is a slow and potentially costly operation. Proceed?"; then
        echo "Aborted by user."
        exit 0
    fi
    
    echo "--> Triggering a fresh deployment first..."
    task deploy

    local module_files
    module_files=$(find . -name "go.mod" -not -path "./.idx/*")
    if [ -z "$module_files" ]; then return; fi

    echo "$module_files" | while read -r mod_file; do
        local module_dir
        module_dir=$(dirname "$mod_file")
        # FIX: Correctly quote the string for gum style.
        gum style --bold --padding "0 1" -- "Running integration tests for module: $module_dir"
        (
            cd "$module_dir"
            go test -v -tags=integration ./...
        )
    done
}

show_coverage_report() {
    if [ ! -f coverage.out ]; then
        gum style --bold --foreground 196 "Error: Coverage report 'coverage.out' not found."
        echo "Please run a unit test suite first to generate the report."
        exit 1
    fi
    echo "--> Opening HTML coverage report in your browser..."
    go tool cover -html=coverage.out
}


# --- Main Controller Logic ---

if [ "$#" -gt 0 ]; then
    case "$1" in
        --unit)
            gum style --bold -- "--- Non-Interactive: Running Unit Tests ---"
            run_unit_tests
            ;;
        --race)
            gum style --bold -- "--- Non-Interactive: Running Race Tests ---"
            run_race_tests
            ;;
        *)
            gum style --bold --foreground 196 "Error: Unknown flag '$1' for non-interactive mode."
            echo "Valid flags are: --unit, --race"
            exit 1
            ;;
    esac
else
    # FIX: Correctly quote the string for gum style.
    gum style --border double --border-foreground 212 --padding "1 2" -- "--- 🧪 Test Suite Runner ---"
    CHOICE=$(gum choose \
        "Unit Tests (Fast)" \
        "Unit Tests (with Race Detector)" \
        "Integration Tests (Slow, requires configured GCP)" \
        "View HTML Coverage Report" \
        "Quit")

    case "$CHOICE" in
        "Unit Tests (Fast)")
            run_unit_tests
            ;;
        "Unit Tests (with Race Detector)")
            run_race_tests
            ;;
        "Integration Tests (Slow, requires configured GCP)")
            run_integration_tests
            ;;
        "View HTML Coverage Report")
            show_coverage_report
            ;;
        *)
            echo "Aborted."
            exit 0
            ;;
    esac
fi

echo
gum style --bold "✅ Test run complete."

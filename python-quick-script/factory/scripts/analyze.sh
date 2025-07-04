#!/bin/bash
set -e
source "$(dirname "$0")/_automation_helpers.sh"
header "Analyzing Python Code Quality"
if ! command -v flake8 &> /dev/null; then
    error "flake8 could not be found. Please ensure it's installed in your environment."
    exit 1
fi
flake8 .
success "Python analysis complete."

#!/bin/bash
set -e
source "$(dirname "$0")/_automation_helpers.sh"
header "Running Python Tests"
if ! command -v pytest &> /dev/null; then
    error "pytest could not be found. Please ensure it's installed in your environment."
    exit 1
fi
pytest
success "Python tests completed successfully."

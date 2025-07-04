#!/bin/bash
set -e
source "$(dirname "$0")/_automation_helpers.sh"
header "Running Python Application"
if [ ! -f "main.py" ]; then
    error "main.py not found. Cannot run the application."
    exit 1
fi
python3 main.py
success "Python script finished."

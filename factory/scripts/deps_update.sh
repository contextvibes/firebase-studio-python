#!/bin/bash
set -e
source "$(dirname "$0")/_automation_helpers.sh"
header "Updating Python Dependencies"
if [ ! -f "requirements.txt" ]; then
    warn "No requirements.txt file found. Nothing to update."
    exit 0
fi
pip install --upgrade -r requirements.txt
success "Python dependencies updated."

#!/bin/bash
set -e
source "$(dirname "$0")/_automation_helpers.sh"
header "Build Step"
info "Python is an interpreted language, so no build step is required."
info "This task is a no-op for Python projects."
success "Build step skipped as expected."

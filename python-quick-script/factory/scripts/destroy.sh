#!/bin/bash
# factory/scripts/destroy.sh
#
# WHAT: A heavily guarded GUIDE to deleting all project infrastructure.
# WHY:  This script does NOT perform any destructive actions itself. It provides
#       a clear checklist of the manual gcloud commands the user must execute,
#       ensuring they are fully aware of the actions being taken.

set -e

# --- Main Logic ---

gum style --border normal --border-foreground 196 --padding "1 2" \
  -- "$(gum style --bold --foreground 196 'DANGER ZONE')" \
  "You are about to be shown the commands to permanently delete all GCP projects for this environment.
This action is irreversible and will result in data loss.
You must run each command manually to confirm."

# Create an array of the projects to delete from environment variables.
PROJECTS_TO_DELETE=(
  "\$COMPUTE_PROJECT_ID"
  "\$STORAGE_PROJECT_ID"
  "\$ASSETS_PROJECT_ID"
)

echo
gum style --bold -- "--- Manual Deletion Checklist ---"
echo "To permanently destroy your infrastructure, you must run the following commands"
echo "manually in your terminal. Please review each one carefully."
echo

# Loop through each project and print the command to delete it.
for PROJECT_ID in "\${PROJECTS_TO_DELETE[@]}"; do
  if [ -z "\$PROJECT_ID" ]; then
    gum style --faint "--> One of the project ID variables is not set. Skipping."
    continue
  fi
  echo
  gum style --bold -- "--- To Delete Project: $(gum style --foreground 212 "\$PROJECT_ID") ---"
  echo "1. Set the active project:"
  gum style --background 236 --padding "0 1" "gcloud config set project \${PROJECT_ID}"
  echo
  echo "2. Run the deletion command:"
  gum style --background 196 --foreground 255 --padding "0 1" "gcloud projects delete \${PROJECT_ID}"
  echo
done

echo
gum style --bold "✅ End of destruction checklist."

#!/bin/bash
# factory/scripts/provision.sh
# Displays a comprehensive, dynamic checklist for provisioning the environment.

set -e

# REASON: This helper function centralizes the logic for printing section
# headers, reducing code duplication and improving maintainability. This aligns
# with the "small, focused functions" principle.
print_header() {
    local title="$1"
    echo
    gum style --bold --padding "0 1" -- "--- ${title} ---"
}

# REASON: This function provides explicit error handling, a core principle of
# our quality guidelines. It ensures the script fails fast with a clear message
# if the required environment variables from .env are not available.
check_vars() {
    local missing_vars=()
    local required_vars=(
        "ASSETS_PROJECT_ID" "ARTIFACT_REGISTRY_NAME" "ASSETS_GCP_REGION"
        "STORAGE_PROJECT_ID" "GCS_BUCKET_NAME"
        "COMPUTE_PROJECT_ID"
    )

    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            missing_vars+=("$var")
        fi
    done

    if [ ${#missing_vars[@]} -ne 0 ]; then
        gum style --border normal --margin "1" --padding "1 2" --border-foreground 99 \
            "❌ ERROR: Required environment variables are not set." \
            "Please ensure the following variables are defined in your .env file:
            $(printf '\n- %s' "${missing_vars[@]}")"
        exit 1
    fi
}

# --- Main Execution Block ---

# ADDED: Run the variable check before proceeding.
check_vars

gum style --border double --border-foreground 212 --padding "1 2" -- "--- 🚀 Infrastructure Provisioning Guide ---"

echo
gum style --bold -- "Three-Project Setup (Recommended Best Practice)"
echo "This project is designed to use three separate GCP projects to enhance"
echo "security, IAM separation, and billing clarity:"
echo "  🎨 Assets Project:  Holds the container images in Artifact Registry."
echo "  📦 Storage Project: Holds the GCS buckets and application data."
echo "  ⚙️  Compute Project: Holds the Cloud Run job and its service accounts."

# REFACTOR: Replaced repeated gum commands with the print_header function.
print_header "1. 🎨 Assets Project Checklist (${ASSETS_PROJECT_ID})"
echo "   [ ] GCP Project should exist with ID '${ASSETS_PROJECT_ID}'."
echo "   [ ] Billing should be enabled for the project."
echo "   [ ] API 'artifactregistry.googleapis.com' should be enabled."
echo "   [ ] A Docker Artifact Registry repository named '${ARTIFACT_REGISTRY_NAME}' should exist in region '${ASSETS_GCP_REGION}'."

print_header "2. 📦 Storage Project Checklist (${STORAGE_PROJECT_ID})"
echo "   [ ] GCP Project should exist with ID '${STORAGE_PROJECT_ID}'."
echo "   [ ] Billing should be enabled for the project."
echo "   [ ] API 'storage.googleapis.com' should be enabled."
echo "   [ ] A GCS Bucket named '${GCS_BUCKET_NAME}' should exist."

print_header "3. ⚙️  Compute Project Checklist (${COMPUTE_PROJECT_ID})"
echo "   [ ] GCP Project should exist with ID '${COMPUTE_PROJECT_ID}'."
echo "   [ ] Billing should be enabled for the project."
echo "   [ ] APIs 'run.googleapis.com' and 'iam.googleapis.com' should be enabled."

gum style --italic -- "--> Fetching dynamic data for IAM checklist..."
CURRENT_USER=$(gcloud config get-value account --quiet)
COMPUTE_PROJECT_NUMBER=$(gcloud projects describe "${COMPUTE_PROJECT_ID}" --format='value(projectNumber)' --quiet 2>/dev/null || echo "COMPUTE_PROJECT_NUMBER_NOT_FOUND")
gum style --faint -- "    (Running as user: ${CURRENT_USER})"

print_header "4. 🔑 IAM Permissions Checklist"
echo "   [ ] DEVELOPER (to push images): Your account (${CURRENT_USER}) needs the 'Artifact Registry Writer' role on the Assets Project '${ASSETS_PROJECT_ID}'."
echo "   [ ] DEPLOYMENT (to pull images): The Cloud Run Service Agent (service-${COMPUTE_PROJECT_NUMBER}@gcp-sa-run.iam.gserviceaccount.com) of the Compute Project needs the 'Artifact Registry Reader' role on the Assets Project '${ASSETS_PROJECT_ID}'."

echo
gum style --bold -- "✅ End of provisioning checklist."

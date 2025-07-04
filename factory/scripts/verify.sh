#!/bin/bash
# factory/scripts/verify.sh
# An automated health check for the project's GCP infrastructure.

set -e

# --- Helper Function for Running and Reporting Checks ---
# WHAT: A helper to run a command, display its status, and show a fix if it fails.
# WHY:  Centralizes the reporting logic for all checks, making the script cleaner.
run_check() {
    local description="$1"
    local command_to_run="$2"
    local fix_suggestion="$3"

    echo -n "› Verifying: $description... "
    if eval "$command_to_run" &> /dev/null; then
        gum style --foreground 46 "[OK]"
    else
        gum style --foreground 196 "[FAIL]"
        gum style --faint "  └─ Suggestion: $fix_suggestion"
    fi
}

# --- Main Verification Logic ---
gum style --border double --border-foreground 212 --padding "1 2" "--- 🔎 Infrastructure Health Verification ---"

# 1. Fetch dynamic values needed for checks
gum style --bold --padding "0 1" "--- 1. Fetching Dynamic Project Data ---"
echo "--> Fetching current user and project numbers..."
CURRENT_USER=$(gcloud config get-value account --quiet)
COMPUTE_PROJECT_NUMBER=$(gcloud projects describe "$COMPUTE_PROJECT_ID" --format='value(projectNumber)' --quiet)
echo "    - Verifying as user: ${CURRENT_USER}"
echo "    - Compute Project Number: ${COMPUTE_PROJECT_NUMBER}"

# --- 2. Verify Projects ---
echo
gum style --bold --padding "0 1" "--- 2. Verifying GCP Project Existence & Status ---"
run_check "Assets Project '${ASSETS_PROJECT_ID}' is ACTIVE" \
    "gcloud projects describe \"$ASSETS_PROJECT_ID\" --format=\"value(lifecycleState)\" | grep -q 'ACTIVE'" \
    "gcloud projects create \"${ASSETS_PROJECT_ID}\" ..."

run_check "Storage Project '${STORAGE_PROJECT_ID}' is ACTIVE" \
    "gcloud projects describe \"$STORAGE_PROJECT_ID\" --format=\"value(lifecycleState)\" | grep -q 'ACTIVE'" \
    "gcloud projects create \"${STORAGE_PROJECT_ID}\" ..."

run_check "Compute Project '${COMPUTE_PROJECT_ID}' is ACTIVE" \
    "gcloud projects describe \"$COMPUTE_PROJECT_ID\" --format=\"value(lifecycleState)\" | grep -q 'ACTIVE'" \
    "gcloud projects create \"${COMPUTE_PROJECT_ID}\" ..."

# --- 3. Verify Enabled APIs ---
echo
gum style --bold --padding "0 1" "--- 3. Verifying Required GCP APIs ---"
run_check "API 'artifactregistry.googleapis.com' is enabled in Assets Project" \
    "gcloud services list --enabled --project=\"$ASSETS_PROJECT_ID\" --filter='config.name:artifactregistry.googleapis.com' --format='value(config.name)' | grep -q 'artifactregistry'" \
    "gcloud services enable artifactregistry.googleapis.com --project='${ASSETS_PROJECT_ID}'"

run_check "API 'storage.googleapis.com' is enabled in Storage Project" \
    "gcloud services list --enabled --project=\"$STORAGE_PROJECT_ID\" --filter='config.name:storage.googleapis.com' --format='value(config.name)' | grep -q 'storage'" \
    "gcloud services enable storage.googleapis.com --project='${STORAGE_PROJECT_ID}'"

run_check "API 'run.googleapis.com' is enabled in Compute Project" \
    "gcloud services list --enabled --project=\"$COMPUTE_PROJECT_ID\" --filter='config.name:run.googleapis.com' --format='value(config.name)' | grep -q 'run'" \
    "gcloud services enable run.googleapis.com --project='${COMPUTE_PROJECT_ID}'"

run_check "API 'iam.googleapis.com' is enabled in Compute Project" \
    "gcloud services list --enabled --project=\"$COMPUTE_PROJECT_ID\" --filter='config.name:iam.googleapis.com' --format='value(config.name)' | grep -q 'iam'" \
    "gcloud services enable iam.googleapis.com --project='${COMPUTE_PROJECT_ID}'"

# --- 4. Verify Specific Resources ---
echo
gum style --bold --padding "0 1" "--- 4. Verifying Specific GCP Resources ---"
run_check "Artifact Registry repo '${ARTIFACT_REGISTRY_NAME}' exists" \
    "gcloud artifacts repositories describe \"$ARTIFACT_REGISTRY_NAME\" --project=\"$ASSETS_PROJECT_ID\" --location=\"$ASSETS_GCP_REGION\"" \
    "gcloud artifacts repositories create \"${ARTIFACT_REGISTRY_NAME}\" --repository-format=docker --location=\"${ASSETS_GCP_REGION}\" --project=\"${ASSETS_PROJECT_ID}\""

run_check "GCS Bucket 'gs://${GCS_BUCKET_NAME}' exists" \
    "gsutil ls -b \"gs://${GCS_BUCKET_NAME}\"" \
    "gsutil mb -p \"${STORAGE_PROJECT_ID}\" \"gs://${GCS_BUCKET_NAME}\""

run_check "Cloud Run Job '${CLOUD_RUN_JOB_NAME}' exists" \
    "gcloud run jobs describe \"$CLOUD_RUN_JOB_NAME\" --project=\"$COMPUTE_PROJECT_ID\" --region=\"$COMPUTE_GCP_REGION\"" \
    "task deploy"

# --- 5. Verify IAM Permissions ---
echo
gum style --bold --padding "0 1" "--- 5. Verifying Key IAM Permissions ---"
CLOUD_RUN_SERVICE_AGENT="service-${COMPUTE_PROJECT_NUMBER}@gcp-sa-run.iam.gserviceaccount.com"
EFFECTIVE_SA=${TARGET_PRINCIPAL_SA}

run_check "Developer (${CURRENT_USER}) has 'Artifact Registry Writer' on Assets Project" \
    "gcloud projects get-iam-policy \"$ASSETS_PROJECT_ID\" --flatten='bindings[].members' --filter=\"bindings.role='roles/artifactregistry.writer' AND bindings.members='user:${CURRENT_USER}'\" --format='value(bindings.members)' | grep -q \"${CURRENT_USER}\"" \
    "gcloud projects add-iam-policy-binding '${ASSETS_PROJECT_ID}' --member='user:${CURRENT_USER}' --role='roles/artifactregistry.writer'"

run_check "Cloud Run Service Agent has 'Artifact Registry Reader' on Assets Project" \
    "gcloud projects get-iam-policy \"$ASSETS_PROJECT_ID\" --flatten='bindings[].members' --filter=\"bindings.role='roles/artifactregistry.reader' AND bindings.members='serviceAccount:${CLOUD_RUN_SERVICE_AGENT}'\" --format='value(bindings.members)' | grep -q \"${CLOUD_RUN_SERVICE_AGENT}\"" \
    "gcloud projects add-iam-policy-binding '${ASSETS_PROJECT_ID}' --member='serviceAccount:${CLOUD_RUN_SERVICE_AGENT}' --role='roles/artifactregistry.reader'"

run_check "Job SA (${EFFECTIVE_SA}) has 'Storage Object Admin' on GCS Bucket" \
    "gsutil iam get \"gs://${GCS_BUCKET_NAME}\" | grep -A 2 'roles/storage.objectAdmin' | grep -q \"serviceAccount:${EFFECTIVE_SA}\"" \
    "gsutil iam ch 'serviceAccount:${EFFECTIVE_SA}:objectAdmin' 'gs://${GCS_BUCKET_NAME}'"


echo
gum style --bold "✅ Verification Complete."
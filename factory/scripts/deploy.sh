#!/bin/bash
# factory/scripts/deploy.sh
# This script orchestrates the entire deployment process. It builds, pushes,
# and then deploys the container to Cloud Run.

# Exit immediately if any command fails.
set -e

# FIX: Added '--' to tell 'gum' to treat the following string as text, not a flag.
gum style --border double --border-foreground 212 --padding "1 2" -- "--- 🚀 Application Deployment ---"

# --- 1. Define Variables ---
gum style --bold --padding "0 1" -- "--- 1. Gathering Deployment Variables ---"

# These variables are passed from the calling Taskfile, which sources .env
ARTIFACT_REGISTRY_REPO="${ASSETS_GCP_REGION}-docker.pkg.dev/${ASSETS_PROJECT_ID}/${ARTIFACT_REGISTRY_NAME}"
GIT_COMMIT=$(git rev-parse --short HEAD)
IMAGE_FQN="${ARTIFACT_REGISTRY_REPO}/${CONTAINER_NAME}"
PROJECT_NUMBER=$(gcloud projects describe "$COMPUTE_PROJECT_ID" --format='value(projectNumber)')
DEFAULT_SA="${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"
EFFECTIVE_SA=${TARGET_PRINCIPAL_SA:-$DEFAULT_SA}

# Use the gcloud '^;^' prefix to change the delimiter, allowing commas in our env vars.
ENV_VARS_STRING="^;^TARGET_USER_EMAILS=${TARGET_USER_EMAILS};GCS_BUCKET_NAME=${GCS_BUCKET_NAME};TARGET_PRINCIPAL_SA=${EFFECTIVE_SA};GOOGLE_CLOUD_PROJECT=${COMPUTE_PROJECT_ID};LOG_LEVEL=${LOG_LEVEL}"

echo "--> Image will be tagged as: ${IMAGE_FQN}:${GIT_COMMIT}"
echo "--> Job will be deployed to project: ${COMPUTE_PROJECT_ID}"
echo "--> Job will run as service account: ${EFFECTIVE_SA}"

# --- 2. Build and Push Container ---
echo
gum style --bold --padding "0 1" -- "--- 2. Building & Pushing Container Image ---"
echo "--> Authenticating Docker with Google Artifact Registry..."
gcloud auth configure-docker "${ASSETS_GCP_REGION}-docker.pkg.dev" --quiet

# REFACTOR: Temporarily removed 'gum spin' to expose raw Docker build errors for debugging.
echo "--> Building for linux/amd64 and pushing (verbose debug mode)..."
docker buildx build   --file factory/Dockerfile   --platform linux/amd64   -t "${IMAGE_FQN}:${GIT_COMMIT}"   -t "${IMAGE_FQN}:latest"   --push   .

# --- 3. Deploy to Cloud Run ---
echo
gum style --bold --padding "0 1" -- "--- 3. Deploying to Google Cloud Run ---"
echo "--> Deploying job '${CLOUD_RUN_JOB_NAME}' to region '${COMPUTE_GCP_REGION}'..."
gum spin --spinner dot --title "Deploying to Cloud Run..." -- gcloud run jobs deploy "${CLOUD_RUN_JOB_NAME}"   --image "${IMAGE_FQN}:${GIT_COMMIT}"   --region "${COMPUTE_GCP_REGION}"   --service-account "${EFFECTIVE_SA}"   --set-env-vars="${ENV_VARS_STRING}"   --project="${COMPUTE_PROJECT_ID}"   --quiet

echo
gum style --bold "✅ Deployment complete."

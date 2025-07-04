#!/bin/bash
# factory/scripts/release.sh
# This script performs a versioned release, including safety checks,
# git tagging, building, pushing, and deploying.

set -e

# --- 1. Input Validation ---
VERSION=$1
if [ -z "$VERSION" ]; then
  gum style --bold --foreground 196 "Error: No version tag provided." >&2
  echo "Usage: task release -- v1.2.3" >&2
  exit 1
fi

# FIX: Correctly quote the string for gum style.
gum style --border double --border-foreground 212 --padding "1 2" -- "--- 📦 Releasing Version: $(gum style --bold "$VERSION") ---"

# --- 2. Pre-flight Safety Checks ---
# FIX: Correctly quote the string for gum style.
gum style --bold --padding "0 1" -- "--- 1. Running Pre-flight Safety Checks ---"

if ! git diff --quiet --exit-code; then
  gum style --bold --foreground 196 "Error: You have uncommitted changes. Please commit or stash them before releasing." >&2
  exit 1
fi
echo "✅ Git working directory is clean."

if git rev-parse -q --verify "refs/tags/${VERSION}" >/dev/null; then
  gum style --bold --foreground 196 "Error: Git tag '${VERSION}' already exists." >&2
  exit 1
fi
echo "✅ Git tag '${VERSION}' is available."

# This script now runs its own non-interactive tests to be self-contained.
# NOTE: This uses `task test -- --unit` to pass the --unit flag to the underlying script.
gum spin --spinner dot --title "Running unit tests..." -- \
    task test -- --unit
echo "✅ All unit tests passed."

gum style --bold "✅ Pre-flight checks complete."

# --- 3. Tagging and Deployment ---
# FIX: Correctly quote the string for gum style.
gum style --bold --padding "0 1" -- "--- 2. Building, Pushing, and Deploying ---"
GIT_COMMIT=$(git rev-parse --short HEAD)
IMAGE_FQN="${ARTIFACT_REGISTRY_REPO}/${CONTAINER_NAME}"
PROJECT_NUMBER=$(gcloud projects describe "$COMPUTE_PROJECT_ID" --format='value(projectNumber)')
DEFAULT_SA="${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"
EFFECTIVE_SA=${TARGET_PRINCIPAL_SA:-$DEFAULT_SA}
ENV_VARS_STRING="^;^TARGET_USER_EMAILS=${TARGET_USER_EMAILS};GCS_BUCKET_NAME=${GCS_BUCKET_NAME};TARGET_PRINCIPAL_SA=${EFFECTIVE_SA};GOOGLE_CLOUD_PROJECT=${COMPUTE_PROJECT_ID};LOG_LEVEL=${LOG_LEVEL}"

echo "--> Creating git tag '${VERSION}'..."
git tag -a "${VERSION}" -m "Release ${VERSION}"

echo "--> Building and pushing container image: ${IMAGE_FQN}:${VERSION}"
gum spin --spinner dot --title "Building container..." -- \
docker buildx build \
  --platform linux/amd64 \
  -t "${IMAGE_FQN}:${VERSION}" \
  -t "${IMAGE_FQN}:latest" \
  --push \
  .

echo "--> Deploying job '${CLOUD_RUN_JOB_NAME}' with image tag '${VERSION}'..."
gum spin --spinner dot --title "Deploying to Cloud Run..." -- \
gcloud run jobs deploy "${CLOUD_RUN_JOB_NAME}" \
  --image "${IMAGE_FQN}:${VERSION}" \
  --region "${COMPUTE_GCP_REGION}" \
  --service-account "${EFFECTIVE_SA}" \
  --set-env-vars="${ENV_VARS_STRING}" \
  --project="${COMPUTE_PROJECT_ID}" \
  --quiet

# --- 4. Finalization ---
# FIX: Correctly quote the string for gum style.
gum style --bold --padding "0 1" -- "--- 3. Finalizing Release ---"
echo "--> Pushing git tag to remote..."
gum spin --spinner dot --title "Pushing git tag..." -- git push origin "${VERSION}"

echo
gum style --bold "✅ Release ${VERSION} is complete."

#!/bin/bash
# factory/scripts/run.sh
# An interactive script to run the application in various modes.

set -e

# --- Helper Functions ---

# Function to build the local binary, used by one of the run modes.
build_binary() {
    gum style --bold "--> Building Go binary into ./bin/..."
    mkdir -p ./bin
    gum spin --spinner dot --title "Compiling..." --         go build -v -o ./bin/florbs-go-job-worker ./cmd/main.go
}

# Function to build the local container image, used by container run modes.
build_container() {
    gum spin --spinner dot --title "Building local container image..." --     docker buildx build         --platform linux/amd64         -t "${IMAGE_FQN}:${GIT_COMMIT}"         -t "${IMAGE_FQN}:latest"         .
}

# --- Main Logic ---

# 1. Define dynamic variables needed for container runs.
GIT_COMMIT=$(git rev-parse --short HEAD)
IMAGE_FQN="${ARTIFACT_REGISTRY_REPO}/${CONTAINER_NAME}"
CURRENT_USER=$(gcloud config get-value account --quiet 2>/dev/null || echo "gcloud-user-not-found")

# 2. Display the interactive menu.
gum style --border double --border-foreground 212 --padding "1 2" -- "--- ▶️  Application Runner ---"
CHOICE=$(gum choose   "Run from local source code as (${CURRENT_USER})"   "Run from compiled binary as (${CURRENT_USER})"   "Run in a single container (index from .env)"   "Run all containers for the job (count from .env)"   "Trigger a remote job on Cloud Run"   "Quit")

# 3. Execute the chosen run mode.
case "$CHOICE" in
    "Run from local source code as (${CURRENT_USER})")
        # REFACTOR: Temporarily removed 'gum spin' to expose raw 'go run' errors.
        echo "--> Running Go application from source (verbose debug mode)..."
        go run ./cmd/main.go
        ;;

    "Run from compiled binary as (${CURRENT_USER})")
        build_binary
        gum spin --spinner dot --title "Running the locally built binary..." --show-output --             ./bin/florbs-go-job-worker
        ;;

    "Run in a single container (index from .env)")
        build_container
        gum style --bold "--> Starting single container for CLOUD_RUN_TASK_INDEX=${CLOUD_RUN_TASK_INDEX}..."
        GIT_COMMIT=${GIT_COMMIT} ARTIFACT_REGISTRY_REPO=${ARTIFACT_REGISTRY_REPO}             docker-compose run --rm --name "worker-${CLOUD_RUN_TASK_INDEX}" florbs-go-job-worker
        ;;

    "Run all containers for the job (count from .env)")
        cleanup() {
            gum style --bold --foreground 212 "--> Shutting down and removing containers..."
            GIT_COMMIT=${GIT_COMMIT} ARTIFACT_REGISTRY_REPO=${ARTIFACT_REGISTRY_REPO}                 docker-compose down --remove-orphans --timeout 5
        }
        trap cleanup EXIT

        build_container
        gum style --bold "--> Starting ${CLOUD_RUN_TASK_COUNT} job containers in the background..."
        for i in $(seq 0 $((CLOUD_RUN_TASK_COUNT - 1))); do
            GIT_COMMIT=${GIT_COMMIT} ARTIFACT_REGISTRY_REPO=${ARTIFACT_REGISTRY_REPO}                 docker-compose run --rm -d --name "worker-$i" -e "CLOUD_RUN_TASK_INDEX=$i" florbs-go-job-worker
        done
        
        gum style --bold --padding "1 0" "✅ All containers started. Streaming logs now (press Ctrl+C to stop)..."
        docker-compose logs -f --tail="all"
        ;;

    "Trigger a remote job on Cloud Run")
        TASK_COUNT=$(echo "${TARGET_USER_EMAILS}" | tr ',' '\n' | wc -l | xargs)
        ENV_VARS_STRING="^;^TARGET_USER_EMAILS=${TARGET_USER_EMAILS};GCS_BUCKET_NAME=${GCS_BUCKET_NAME};TARGET_PRINCIPAL_SA=${TARGET_PRINCIPAL_SA};GOOGLE_CLOUD_PROJECT=${COMPUTE_PROJECT_ID};LOG_LEVEL=${LOG_LEVEL}"

        gum style --bold "--> Triggering remote Cloud Run Job '${CLOUD_RUN_JOB_NAME}' with ${TASK_COUNT} tasks..."
        gum spin --spinner dot --title "Executing remote job..." --             gcloud run jobs update "${CLOUD_RUN_JOB_NAME}"                 --region "${COMPUTE_GCP_REGION}"                 --project "${COMPUTE_PROJECT_ID}"                 --tasks "${TASK_COUNT}"                 --parallelism "${CLOUD_RUN_TASK_PARALISM}"                 --update-env-vars="${ENV_VARS_STRING}"                 --wait
        ;;

    *)
        echo "Aborted."
        exit 0
        ;;
esac

echo
gum style --bold "✅ Run command complete."

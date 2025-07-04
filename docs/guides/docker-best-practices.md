# Filename: docker-go-cloudrun-jobs.md

# AI Instruction Set: Generating Optimal Dockerfiles for Go on Cloud Run Jobs

## 1. Guiding Principles (Project Philosophy)

This project mandates the use of Docker for containerization, emphasizing:

* **Multi-Stage Builds:** To separate build dependencies from the final runtime environment, ensuring the final image is clean and minimal.
* **Distroless Base Images:** Specifically `gcr.io/distroless/static-debian12:nonroot`, to create the smallest possible, most secure final image by excluding unnecessary OS components (like shells or package managers).
* **Overall Goal:** Produce minimal, efficient, reproducible, simple, and secure container images suitable for Google Cloud Run Jobs. Adherence to Quality, Simplicity, and Security principles is paramount.

**The AI must generate Dockerfiles that strictly adhere to these principles and explicitly mention them in the generated file's comments.**

## 2. Core Requirements & Structure (Dockerfile Generation Steps)

1. **Multi-Stage Builds:** ALWAYS use multi-stage builds.
    * Name the build stage `AS builder`.
    * The final stage does not need an explicit name (`AS final` is redundant).

2. **Builder Stage (`AS builder`)**
    * **Base Image:** Use an official `golang:<version>-<base>` image. Pin the version tag explicitly (e.g., `golang:1.23-bookworm`). Prefer stable bases like `bookworm`. Check Docker Hub for the latest appropriate Go versions.
    * **Working Directory:** Set `WORKDIR /app`.
    * **Dependency Caching Strategy:**
        * First: `COPY go.* ./` (Copy only module files).
        * Second: `RUN go mod download` (Download dependencies; leverages Docker cache).
    * **Source Code Copy:**
        * Third: `COPY . .` (Copy the rest of the source code).
        * **Crucial Dependency:** Assume a comprehensive `.dockerignore` file exists in the source repository. This file *must* exclude `.git`, `.env`, local build artifacts (like binaries), test files, IDE configurations, etc., to optimize build context size and prevent secret leaks.
    * **Build Command:** Compile a static, Linux/AMD64 binary suitable for Cloud Run.
        * Use the command: `RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build ...`
        * **Required Go Build Flags:**
            * `-ldflags="-s -w"`: Strips symbol table (`-s`) and DWARF debug info (`-w`) for a smaller binary.
            * `-trimpath`: Removes local filesystem paths for better reproducibility.
            * `-mod=readonly`: Ensures `go.mod`/`go.sum` are not modified during build, enforcing reproducibility.
        * Specify the output path clearly, e.g., `-o /app/server`.
        * The final argument should be the main package path (e.g., `.` if `main.go` is in `/app`, or `./cmd/myapp` if it's in a subdirectory).
        * Include `-v` for verbose build output logging.
        * **Cross-Compilation Note:** If the build environment is *not* Linux/AMD64 (e.g., ARM-based Mac M1/M2), remind the user that `docker buildx build --platform linux/amd64 ...` is required to build the correct image architecture for Cloud Run.

3. **Final Runtime Stage**
    * **Base Image:** Use `gcr.io/distroless/static-debian12:nonroot` (as per project philosophy).
        * **Rationale Reinforcement:** This image provides an extremely minimal base (~2-3 MiB), includes essential CA certificates (for HTTPS), timezone data (`tzdata`), and a pre-configured non-root user (`nonroot`), *without* including shells, package managers, or other unnecessary utilities, significantly reducing the attack surface.
        * **Best Practice Recommendation:** Strongly recommend pinning this base image to a specific digest (`@sha256:...`) in production environments for maximum reproducibility and security against unexpected upstream changes. E.g., `FROM gcr.io/distroless/static-debian12:nonroot@sha256:xxxxxxxx...`
    * **Working Directory:** Optional, but `WORKDIR /` is common and simple for distroless.
    * **Copy Artifacts:**
        * Use `COPY --from=builder <path_in_builder> <path_in_final>`.
        * Copy *only* the compiled application binary: `COPY --from=builder /app/server /server`.
        * If the application requires specific static assets (config files, templates), copy them explicitly from the builder stage as well (e.g., `COPY --from=builder /app/config.yaml /config.yaml`). **Do NOT** copy the entire `/app` directory or source code into the final stage.
    * **User Configuration:** Switch to the non-root user: `USER nonroot`. This instruction should come *after* any `COPY` instructions.
    * **Entrypoint:** Define the container's entrypoint using the **exec form (JSON array)**, which is mandatory for shell-less images like distroless.
        * Example: `ENTRYPOINT ["/server"]`
        * **Critical Context:** This defines the *default* executable. Cloud Run Jobs are designed to override command and arguments (`--command`, `--args`) at runtime. The Go application binary (`/server` in this case) must be designed to parse command-line arguments passed by Cloud Run for specific task execution.

## 3. Security Imperatives Checklist

Ensure the generated Dockerfile and accompanying notes emphasize these:

* **`.dockerignore`:** Its presence and comprehensiveness are assumed and critical.
* **Minimal Attack Surface:** Achieved via multi-stage builds and the `distroless/static-debian12:nonroot` base. No extra tools, shells, or package managers should be added.
* **Non-Root Execution:** Mandatory use of `USER nonroot` in the final stage.
* **Secrets Management:** Explicitly state that secrets (API keys, passwords, certs) MUST NOT be included in the Dockerfile (no `ARG` or `ENV` for sensitive data). Direct users to use Google Secret Manager integration with Cloud Run (mounted as volumes or environment variables at runtime).
* **Vulnerability Scanning:** Recommend integrating automated image vulnerability scanning (e.g., Google Artifact Registry scanning, Trivy, Snyk) into the CI/CD pipeline and rebuilding images frequently to patch base image vulnerabilities.
* **(Advanced) Read-Only Root Filesystem:** Mention that designing the application to work with a read-only root filesystem is an advanced security best practice, though Cloud Run Job configuration for this might be limited.

## 4. Separation of Concerns: Dockerfile vs. Cloud Run Job

It is VITAL to distinguish between the image definition and runtime configuration:

* **Dockerfile Defines:**
  * The immutable contents of the container image (binary, minimal OS files, static assets).
  * The default user (`nonroot`).
  * The default entrypoint executable (`/server`).
* **Cloud Run Job Configuration Defines (at runtime):**
  * Overrides for entrypoint/command (`--command`).
  * Specific arguments passed to the executable (`--args`) for parameterization.
  * Runtime environment variables (non-secret config).
  * Secure injection of secrets (via Secret Manager).
  * Resource allocation (CPU, Memory).
  * Job execution parameters (task count, parallelism, retries, timeout).
  * IAM Service Account identity.

This separation allows a single image to be used flexibly for various job tasks.

## 5. Output Format & Required Content for Generated Dockerfile

The AI's output **must** be the Dockerfile content itself, formatted correctly, and including the following:

1. **Introductory Comments:** Start the Dockerfile with comments explicitly stating the use of **multi-stage builds** and the **distroless (`gcr.io/distroless/static-debian12:nonroot`) base image** to achieve minimal and secure final container images, reflecting the project philosophy.
2. **Explanatory Comments:** Add comments within the Dockerfile stages explaining key commands or choices (e.g., why `go mod download` is separate, the purpose of build flags, the reason for distroless).
3. **Security Notes Section:** Include a commented section summarizing key security reminders (use `.dockerignore`, vulnerability scanning, secrets management via Cloud Run).
4. **MANDATORY References Section:** Conclude the Dockerfile with a commented section titled `# --- References Consulted ---`. This section **must** list the URLs of key external resources referenced or consulted during the generation of *that specific* Dockerfile. At a minimum, include relevant links from:
    * `https://docs.docker.com/` (e.g., multi-stage builds, best practices)
    * `https://cloud.google.com/run/docs/` (e.g., containers, jobs, security, secrets)
    * `https://github.com/GoogleContainerTools/distroless`
    * Any specific influential blog posts or articles (e.g., `https://laurentsv.com/blog/...` if used).
    * Specific Go documentation if relevant flags were looked up.
    * Any other authoritative sources consulted by the AI for that generation task.

## Example Snippet (Illustrative Structure - AI generates the full, detailed file)

```dockerfile
# Dockerfile for Go Application on Cloud Run Jobs
# --- Project Philosophy ---
# This Dockerfile adheres to project standards by utilizing multi-stage builds
# and the gcr.io/distroless/static-debian12:nonroot base image.
# This approach creates a minimal, secure, and efficient container image
# suitable for ephemeral Cloud Run Jobs.
# ---

# Stage 1: Build Stage - Compiles the Go application
# Using pinned Go version for reproducibility.
FROM golang:1.23-bookworm AS builder

# Set working directory
WORKDIR /app

# Cache dependencies based on module files
COPY go.* ./
RUN go mod download

# Copy remaining source code (ensure .dockerignore excludes unnecessary files)
COPY . .

# Build static, optimized binary for Linux/AMD64 (Cloud Run environment)
# - CGO_ENABLED=0: Static linking (no C dependencies)
# - ldflags="-s -w": Strip debug info/symbols -> smaller binary
# - trimpath: Remove local paths -> reproducible builds
# - mod=readonly: Ensure go.mod/go.sum are not modified
# Note: Use 'docker buildx build --platform linux/amd64...' if building on non-AMD64 host (e.g., M1 Mac)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-s -w" \
    -trimpath \
    -mod=readonly \
    -v -o /app/server .
    # Adjust final '.' to specific package path if needed (e.g., ./cmd/myapp)

# ---

# Stage 2: Final Runtime Stage - Creates the minimal production image
# Using distroless static nonroot image for minimal attack surface.
# Includes CA certs, tzdata, and non-root user. No shell/package manager.
# Recommend pinning to digest in production: @sha256:xxxxxxxx...
FROM gcr.io/distroless/static-debian12:nonroot

# Set working directory (optional, '/' is common for distroless)
WORKDIR /

# Copy ONLY the compiled application binary from the builder stage
COPY --from=builder /app/server /server
# COPY --from=builder /app/static-assets/ /static-assets/ # Uncomment/adjust if static assets needed

# Switch to the non-root user for security
USER nonroot

# Define the default entrypoint. Uses exec form (required for distroless).
# Cloud Run Jobs will pass runtime arguments to this binary via --args.
ENTRYPOINT ["/server"]

# --- Security Notes ---
# - Ensure a comprehensive .dockerignore file is used in the project root.
# - Integrate vulnerability scanning (e.g., Artifact Registry scanning) into CI/CD.
# - Manage ALL secrets via Google Secret Manager and Cloud Run integration, NOT in this Dockerfile.
# - Design the application '/server' to accept runtime arguments for parameterization.

# --- References Consulted ---
# [AI: List the actual URLs used for this specific generation below]
# - https://docs.docker.com/build/building/multi-stage/
# - https://docs.docker.com/build/building/best-practices/
# - https://github.com/GoogleContainerTools/distroless
# - https://cloud.google.com/run/docs/configuring/jobs/containers
# - https://cloud.google.com/run/docs/create-jobs
# - https://cloud.google.com/run/docs/securing/secrets
# - https://golang.org/cmd/go/#hdr-Build_modes
# - [Add any other specific URLs consulted by the AI here]

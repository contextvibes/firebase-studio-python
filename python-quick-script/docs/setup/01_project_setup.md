# Guide: Setting Up the Google Cloud Project

This document walks you through the process of creating and configuring the Google Cloud Project required to run this application.

Follow these steps in order, executing the commands in your local terminal where `gcloud` is authenticated.

---

### **Step 1: Configure Your Environment**

First, we need to set the environment variables that will parameterize the rest of the commands.

**Action:** Copy the block below, replace the placeholder values with your actual information, and then run the `export` commands in your terminal session.

```bash
# Replace the placeholder values before running!
export GCP_PROJECT_ID="your-unique-project-id"
export GCP_BILLING_ACCOUNT_ID="012345-6789AB-CDEF01"
export GCP_REGION="us-central1"
export ORGANIZATION_ID="123456789012" # Optional: Your GCP Organization ID

# --- Verification ---
# Run this command to ensure your variables are set correctly.
echo "Project ID: $GCP_PROJECT_ID, Region: $GCP_REGION"
```

---

### **Step 2: Create the Google Cloud Project**

This command creates the new GCP project if it doesn't already exist.

**Action:** Run the following `gcloud` command.

```bash
gcloud projects create ${GCP_PROJECT_ID} --name="${GCP_PROJECT_ID}" --organization=${ORGANIZATION_ID}
```

> **Note:** If your project already exists, you will see an error indicating that, which is safe to ignore. If you are not using an organization, you can remove the `--organization` flag.

---

### **Step 3: Link the Billing Account**

A project must be linked to a billing account to use most Google Cloud services.

**Action:** Run the following `gcloud` command.

```bash
gcloud billing projects link ${GCP_PROJECT_ID} \
    --billing-account=${GCP_BILLING_ACCOUNT_ID}
```

---

### **Step 4: Enable Required APIs**

This command enables the core APIs needed for Cloud Run, Artifact Registry, and IAM management.

**Action:** Run the following `gcloud` command.

```bash
gcloud services enable \
    run.googleapis.com \
    artifactregistry.googleapis.com \
    iam.googleapis.com \
    cloudresourcemanager.googleapis.com \
    --project=${GCP_PROJECT_ID}
```

---

### **Setup Complete**

Your Google Cloud project is now configured with the basic services required. You can proceed with deploying the application.

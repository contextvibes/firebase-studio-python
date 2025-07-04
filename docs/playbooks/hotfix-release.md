# Playbook: Hotfix Release Workflow

**DANGER:** This playbook describes a high-risk procedure for creating a release directly from the `main` branch. This should **ONLY** be used for critical, production-breaking bugs that cannot wait for the standard release cycle.

### **Phase 1: Pre-flight Checks**

Before starting, ensure you are on the `main` branch and have pulled the very latest code.

**Commands:**

```bash
# git checkout main
# git pull
```

### **Phase 2: Implement the Fix**

Make the necessary code changes *directly on the main branch*. Be extremely careful to only include the minimal changes required to fix the bug.

### **Phase 3: Commit and Tag**

Commit the fix with a message that clearly identifies it as a hotfix. Then, use the `release` command to tag this commit with a new version number. Hotfix versions should typically increment the patch version (e.g., `v1.2.3` -> `v1.2.4`).

**Commands:**

```bash
# task commit -- -m "fix: resolve critical login issue (hotfix)"
# task release -- v1.2.4
```

The `release` command will automatically run tests, build, and deploy the new version. Monitor the deployment closely.

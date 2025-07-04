# Playbook: Standard Feature Workflow

This playbook guides you through the standard, best-practice workflow for developing a new feature using the THEA command menu.

### **Phase 1: Start the Task**

Begin by creating a new, dedicated Git branch for your task. Use a descriptive name that includes the ticket number if applicable (e.g., `feat/TICKET-123-add-user-auth`).

**Command:**

```bash
# task task-start -- feat/TICKET-123-add-user-auth
```

### **Phase 2: Develop and Commit**

Write your code and tests. As you reach logical stopping points, commit your work with clear, descriptive messages.

**Commands:**

```bash
# Check the status of your files
# task status

# Commit your changes
# task commit -- -m "feat: add user authentication endpoint"
```

### **Phase 3: Finish the Task**

Once your feature is complete and you have committed all your changes, it's time to create a pull request. The `task-finish` command will sync your branch with the remote repository and then open your web browser to the "New Pull Request" page on GitHub, pre-filled with your branch details.

**Command:**

```bash
# task task-finish
```

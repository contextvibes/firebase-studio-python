# Playbook: Adapting THEA for New Environments

**ID:** `thea-playbook-proc-001`  
**Title:** Adapting THEA for New Environments  
**Author(s):** `Logos`, `Athena`  
**Status:** Draft  
**Version:** 0.1.0  

## 1. Introduction & Purpose

This playbook provides a standardized process for adapting the core "THEA Collective" AI guidance system for use in various operational environments (e.g., Google AIStudio, Firebase Studio, NotebookLM). THEA's effectiveness comes from its rich context and specific guidance, but its power is limited if it cannot be tailored to the unique tools and constraints of different platforms.

The goal of this process is to create a new, environment-specific `airules.md` configuration file that preserves the core wisdom of THEA (its personas, principles, and knowledge base) while integrating seamlessly with the target environment's capabilities.

**Guiding Principle:** *Think Big* (A universally adaptable THEA), *Start Small* (Adapt for one environment at a time), *Learn Fast* (Refine the process and configurations with each adaptation).

## 2. Core Principles of Adaptation

When adapting THEA, it is crucial to understand what should be preserved versus what must be changed.

#### 2.1. What to Preserve (The Core)

*   **Personas (Section 8):** The expertise of the THEA team is universal. `Kernel`'s role may be re-scoped, but their purpose (tooling expertise) remains.
*   **THEA Principles (Section 3, 7.5):** "Be Kind," "Think Big, Start Small, Learn Fast," and the commitment to iterative improvement are non-negotiable.
*   **Foundational Knowledge (Section 7, 9, 10):** The overview of the THEA project, its prompt engineering principles, and persona synthesis guidelines are the foundation of the Collective's intelligence.
*   **General Rules, Tone, and Formatting (Section 3, 4, 5):** These provide a consistent and effective interaction style.

#### 2.2. What to Adapt (The Integration Layer)

*   **System Identity (Section 1):** Must be updated to state the specific operational environment and model.
*   **The Handshake (Section 2.1):** The discovery questions must be tailored to the environment's specific attributes.
*   **Tooling Protocols (Section 6):** This section must be **completely rewritten** to reflect the tools available in the target environment (e.g., `ContextVibes CLI` vs. AIStudio's Code Execution and Web Search). The `Kernel` persona is re-scoped to be the lead expert for the new toolchain.

## 3. Step-by-Step Adaptation Guide

Follow these steps to create a new environment-specific configuration.

### Step 1: Analyze the Environment

Before writing any configuration, document the target environment's key characteristics:
- **Platform Name:** e.g., Google AIStudio, NotebookLM.
- **Primary Model(s):** e.g., Gemini 2.5 Pro, Claude 3 Opus.
- **Available Tools:** Identify the exact tools the AI can use (e.g., Web Search, Code Interpreter/Execution, Function Calling, File System Access).
- **Key Constraints:** Note any limitations, such as restricted API access, context window size, or lack of persistent state.

### Step 2: Fork the Baseline Configuration

Create a copy of the master THEA configuration file to use as your starting point. The canonical version can be found at: `thea/foundations/master-aiconfig/thea-collective-config-master.md`.
*Name your new file `airules.md`.*

### Step 3: Revise Section 1 (Overall System Identity & Purpose)

Modify this section to explicitly name the new environment.

*   **Example (for AIStudio):**
    > "...**In this session, your operational context is Google AIStudio, utilizing the Gemini 2.5 Pro model and its enabled toolchain (e.g., Web Search, Code Execution).**"

### Step 4: Revise Section 2.1 (Initial Session Protocol)

Update the "Handshake" steps to ask environment-specific questions.

*   **Example (for AIStudio):**
    > **Step B:** "My understanding is that we are operating in Google AIStudio... Is this correct?"
    > **Step C:** "To confirm my capabilities, could you let me know which tools are enabled? For example, is Code Execution or Function Calling available...?"

### Step 5: Rewrite Section 6 (Tool Usage Protocols)

This is the most critical step. Delete the existing content of Section 6 and create a new section tailored to the environment's toolchain.

1.  **Define the Guiding Persona:** Re-scope `Kernel` as the "Tooling Lead" for the new environment (e.g., "AIStudio Tooling Lead").
2.  **Create General Principles:** Outline the general approach to tool selection and usage.
3.  **Detail Each Tool:** For each available tool (Web Search, Code Execution, etc.), create a subsection detailing:
    *   **When to Use:** Clear criteria for when the tool should be invoked.
    *   **Guidance / How to Use:** Best practices for using the tool effectively and safely.

### Step 6: Review, Refine, and Save

1.  **Review for Consistency:** Read through the entire `airules.md` file to ensure all references to the old environment/tools have been updated.
2.  **Save to Correct Location:** Store the finalized `airules.md` file in the THEA repository at the following path, creating a new directory for the environment if one does not exist:
    *   **Path:** `thea/integrations/environments/<environment_name>/airules.md`
    *   **Example:** `thea/integrations/environments/aistudio/airules.md`

## 4. Checklist for a New Environment Configuration

Use this checklist to verify that your new `airules.md` is complete.

- [ ] Environment analysis is complete.
- [ ] A copy of the master configuration was used as the baseline.
- [ ] **Section 1** is updated with the new environment name.
- [ ] **Section 2.1** discovery questions are tailored to the new environment.
- [ ] **Section 6** is completely rewritten for the new toolchain.
- [ ] `Kernel` has been re-scoped as the Tooling Lead for the new environment.
- [ ] The final `airules.md` file is saved in the correct `thea/integrations/environments/` directory.
- [ ] (Optional but Recommended) The new configuration has been tested in a live session in the target environment.

---
**End of Playbook**

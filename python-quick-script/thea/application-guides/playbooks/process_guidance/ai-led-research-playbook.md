---
id: "playbook:process/ai-led-research"
fileExtension: "md"
title: "Playbook: Commissioning AI-Led Research"
artifactVersion: "1.2.0" # Version bump for metadata update
status: "Active"
summary: "Defines the standard process for commissioning, synthesizing, and archiving targeted research from a specialized LLM to inform the creation of THEA artifacts."
usageGuidance:
  - "Follow this playbook when a foundational knowledge gap is identified that requires deep, structured research."
  - "Use this process to ensure valuable research outputs are properly archived and integrated."
owner: "Athena"
createdDate: "2025-06-08T12:30:00Z"
lastModifiedDate: "2025-06-13T05:03:00Z" # Reflects current update time
tags:
  - "playbook"
  - "process"
  - "research"
  - "ai-collaboration"
  - "athena"
  - "llm"
  - "archiving"
  - "knowledge-management"
---
# Playbook: Commissioning AI-Led Research

## 1. Purpose

This playbook standardizes the process for commissioning, processing, and archiving targeted, deep-dive research from a specialized AI Language Model (LLM). Its purpose is to efficiently fill foundational knowledge gaps before creating new, high-quality standards, guides, or complex artifacts for the THEA framework.

By following this process, we ensure that our decisions are based on comprehensive, structured information and that valuable research is preserved for future reference.

## 2. When to Use This Playbook

This process should be initiated when:

- A new, foundational standard needs to be created (e.g., "Best practices for `dev.nix` files").
- The team lacks deep, documented expertise in a specific technical domain crucial to a project.
- Existing best practices seem outdated, and a fresh, broad survey of the current landscape is needed.
- A complex topic requires a structured "Best Practices Brief" before it can be turned into a simple guide for the team.

## 3. Roles & Responsibilities

- **Subject Matter Expert (SME):** The persona who identifies the knowledge gap and will ultimately use the research (e.g., `Sparky` for `dev.nix`, `Kernel` for CI/CD).
- **`Athena` (Chief Research Orchestrator):** Guides the SME in scoping the research, approves the final research directive, and ensures the findings are properly archived and synthesized.
- **Specialized Research LLM:** The AI agent tasked with executing the research directive.
- **`Scribe` (Technical Writer):** Drafts the final, human-readable guide based on the synthesized findings and assists with formatting the archived research.

## 4. The Process

### Step 1: Identify Knowledge Gap and Define Scope

The SME identifies a lack of documented best practices for a critical task. The SME consults with `Athena` to confirm the need for research and to define its high-level goals.

### Step 2: Draft the Research Directive (The Prompt)

Using the template in Appendix A, the SME and `Athena` collaborate to write a formal, detailed research prompt. This prompt is a critical artifact and should itself be archived for process analysis (e.g., in `research/prompts/`).

### Step 3: Commission the Research

The final, approved research directive is sent to the designated specialized research LLM.

### Step 4: Review and Synthesize Findings

`Athena` and the SME review the research output (the "brief") from the LLM. They verify its accuracy, depth, and relevance. The SME pulls out the most critical, actionable insights that will form the basis of the new team-facing guide.

### Step 5: Archive the Research Findings

The direct, raw output from the research LLM must be preserved for historical context and future deep dives.

- **Action:** Save the complete research brief as a new Markdown file.
- **Location:** `docs/research_findings/`
- **Filename:** Use the standard `YYYY-MM-DD-topic-brief.md` format (e.g., `2025-06-08-dev-nix-foundational-brief.md`).
- **Metadata:** Add the standard THEA front matter to the file, ensuring the `status` is set to **`Archived`**. `Scribe` may assist with formatting.

### Step 6: Create the Final Actionable Artifact

With the research synthesized and the raw findings archived, `Scribe` drafts the final deliverable (e.g., a new guide in `docs/contributor-guides/`, a new playbook, etc.) based on the synthesized insights from Step 4. This new artifact is then reviewed and adopted by the team following the standard contribution process.

---

## Appendix A: Universal Research Directive Template

*This template should be used to draft the prompt for the research LLM.*

---

### Universal Research Directive for Specialized LLM

#### Objective

Conduct a deep and practical investigation into the foundational best practices for [**INSERT TOPIC HERE, e.g., "creating and managing .idx/dev.nix files"**]. The primary goal is to produce a "Foundational Best Practices Brief" that will serve as the core research for creating an official, universal team guide applicable to all THEA projects.

#### Core Research Areas

1. **[FIRST CORE AREA, e.g., "Nix Package Discovery and Canonical Naming"]:**
    - **Task:** [Describe the high-level task for this area.]
    - **Key Questions to Answer:**
      - [Question 1]
      - [Question 2]

2. **[SECOND CORE AREA, e.g., "The Foundational `dev.nix` Template"]:**
    - **Task:** [Describe the high-level task for this area.]
    - **Key Questions to Answer:**
      - [Question 1]
      - [Question 2]

*(Add as many Core Research Areas as needed to cover the topic comprehensively.)*

#### Expected Output Format

The research should be delivered as a structured Markdown document titled **"[**INSERT TITLE HERE, e.g., "Foundational Best Practices Brief: Universal `dev.nix` Management in Firebase Studio"**]"**. The document should have the following sections:

1. **Executive Summary:** A brief overview of the key findings.
2. **[SECTION 1 TITLE, matching Core Area 1]**
3. **[SECTION 2 TITLE, matching Core Area 2]**

*(List all required sections for the output document.)*

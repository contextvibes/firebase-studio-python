# Playbook: Creating and Maintaining THEA Project Diagrams

**Version:** 1.1 (Excellence Revision)
**Status:** Active
**Conceptual Owners:** `Canon`, `Logos`, `Scribe`

## 1. Purpose

This playbook establishes the definitive standard for all visual diagrams within the THEA ecosystem. Its purpose is to ensure that our diagrams are not merely illustrative but are clear, maintainable, and professional assets that enhance understanding and accelerate project alignment. Adherence to this playbook is a commitment to quality in our communication.

## 2. Guiding Principles

> **Clarity Over Complexity:** A diagram's primary value is its ability to simplify a complex idea. If a diagram is confusing, it has failed. Strive for minimal, purposeful design.

> **Maintainability is Non-Negotiable:** A diagram without a source file is a dead end. The `.drawio` source file is the **single source of truth** for any diagram, ensuring any team member can update it in the future.

> **Consistency Creates Cohesion:** Following a consistent style guide ensures that our documentation feels like a unified, professional suite of materials, reinforcing the quality of the THEA framework itself.

## 3. Required Tooling

* **Primary Tool:** **diagrams.net (Draw.io)** is the mandatory tool for creating architectural, conceptual, and flow diagrams. Its use of a version-controllable XML source file (`.drawio`) directly supports our maintainability principle.
* **Text-Based Alternative:** **Mermaid.js** may be used *only* for simple sequence diagrams or flowcharts embedded directly in Markdown where visual polish is secondary to raw sequence clarity.
  * **Heuristic:** If a diagram has more than 5-7 distinct steps or requires explaining complex relationships beyond a simple flow, use diagrams.net.

## 4. Rigorous File & Storage Conventions

* **Asset Location:** All diagram assets MUST be located in `docs/assets/images/`.
* **File Naming:** Use descriptive, lowercase, kebab-case names (e.g., `thea-continuous-improvement-cycle.svg`).
* **Formats & Source Control:**
  * The viewable, embedded format MUST be **SVG (`.svg`)**.
  * The editable source format MUST be **diagrams.net (`.drawio`)**.
  * **CRITICAL:** Both the `.svg` and its corresponding `.drawio` source file MUST be committed together in the same commit. This prevents a state where the documentation shows a stale diagram whose source has been lost.

* **Correct Directory Structure Example:**

    ```
    docs/assets/images/
    ├── thea-continuous-improvement-cycle.drawio  <-- Source of Truth
    └── thea-continuous-improvement-cycle.svg     <-- Exported Image
    ```

## 5. Visual Style Guide (v1.0)

To ensure consistency, new diagrams should adhere to the following baseline styles.

| Element           | Style Recommendation                                 |
|-------------------|------------------------------------------------------|
| **Fonts**         | "Helvetica" or a similar clean, sans-serif font.     |
| **Primary Color** | `#4285F4` (Google Blue) for key elements.            |
| **Accent Color**  | `#34A853` (Google Green) for success or positive flow. |
| **Warning Color** | `#FBBC04` (Google Yellow) for warnings or notes.    |
| **Connectors**    | Solid lines with clear arrowheads. Use squared corners. |
| **Shapes**        | Use simple shapes (rectangles, ellipses). Avoid shadows. |

## 6. Detailed Walkthrough: Creating a New Diagram

This section provides a practical, step-by-step example.

1. **Formal Proposal:** First, a need is identified. A GitHub Issue is created, proposing a diagram to illustrate the THEA feedback loop. `Logos` and `Athena` approve the concept.
2. **Creation (diagrams.net):**
    * The author creates the diagram, adhering to the **Visual Style Guide**. Entities (`THEA Guidance System`, `Developer Experience`, etc.) are created.
    * The relationships are mapped with clear, concise labels on the connectors (e.g., "Generates/Improves", "Provides Feedback To").
3. **Export & Save:**
    * The source is saved as `docs/assets/images/thea-continuous-improvement-cycle.drawio`.
    * The diagram is exported as `docs/assets/images/thea-continuous-improvement-cycle.svg`.
4. **Embedding & Documentation:** The SVG is embedded in `README.md`. A reference to this playbook is added for context:

    ```markdown
    ![THEA Continuous Improvement Cycle](docs/assets/images/thea-continuous-improvement-cycle.svg) 
    *(Process for creating and maintaining diagrams: [Playbook: Creating and Maintaining THEA Project Diagrams](playbooks/process_guidance/managing_thea_diagrams.md))*
    ```

5. **Commit & Pull Request:** A PR is opened. The reviewer uses the checklist below to validate the contribution.

## 7. Contributor Checklist (For PR Authors & Reviewers)

Before submitting or approving a PR with diagram changes, ensure every box is checked:

* [ ] **Purposeful:** Does the diagram clearly serve a purpose, simplifying a complex topic?
* [ ] **Tooling Compliant:** Was diagrams.net used for this complex diagram?
* [ ] **Correct Location:** Are all assets located within `docs/assets/images/`?
* [ ] **Naming Convention:** Is the filename lowercase and kebab-cased?
* [ ] **SVG Exported:** Is there a `.svg` file for embedding?
* [ ] **Source File Included:** Is the corresponding `.drawio` source file present?
* [ ] **Committed Together:** Were both `.svg` and `.drawio` files included in the same commit?
* [ ] **Visually Consistent:** Does the diagram reasonably adhere to the Visual Style Guide?
* [ ] **Referenced Correctly:** Is the diagram embedded correctly in its target document?

---
This playbook ensures our visual aids are as professional and maintainable as our code.

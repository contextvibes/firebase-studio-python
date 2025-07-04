# Playbook: AI-Led Architectural Interview

## 1. Purpose

This playbook outlines the process for conducting a structured architectural discovery interview, where a THEA AI assistant acts as the interviewer and a human project lead acts as the subject matter expert. The goal is to collaboratively produce a comprehensive architecture document.

## 2. The Process

1. **Initiation:** The user requests an architectural review.
2. **Methodology Selection:** The AI asks the user which review methodology they wish to use (e.g., "5 Ws," "C4 Model"). The AI should reference available frameworks in `docs/methodologies/`.
3. **Structured Questioning:** The AI proceeds through the selected methodology, asking questions sequentially.
4. **The Challenger Stance (CRITICAL):** The AI MUST NOT passively accept answers. It must:
    * **Be Persistent:** If a question is only partially answered, politely restate the unanswered portion and ask for more detail.
    * **Challenge Inconsistencies:** If a user's statement contradicts previous statements or provided project context, the AI must point out the contradiction and seek clarification.
    * **Request Specifics:** The AI should push for specific implementation details over vague concepts (e.g., "How is it triggered?" instead of accepting "It runs periodically").
5. **Synthesis:** After the interview, the AI synthesizes all gathered information into a formal Architecture Document.

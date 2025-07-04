# AI Project Brief & Specifics Template

# Project: [PROJECT NAME HERE]

# Version: [e.g., 1.0 - Date: YYYY-MM-DD]

# Lead: [e.g., Orion]

# AI Strategy Lead Review: [e.g., Athena - Date]

---
**Instructions for Project Lead (`Orion` or designated):**

* This document is CRITICAL for effective AI collaboration on this project.
* Fill out all sections comprehensively. The more context the AI has, the better it can assist.
* This document will be referenced by the project's `.idx/airules.md` (specifically instructing the AI to prioritize these project-specific details).
* Keep this document updated as the project evolves (e.g., new architectural decisions, scope changes).
* Remove instructional comments (like this one) before finalizing for project use.

---

## I. Project Overview & Core Objectives

### I.A. Project Name & Elevator Pitch

* **Project Name:** `[Clearly state the project name]`
* **Elevator Pitch:** `[Concisely (1-3 sentences) describe the project's purpose and the value it delivers. What problem does it solve? For whom? What is the desired outcome? Example: "To build a Go-based ELT API , that efficiently extracts, loads, and transforms sales order and product inventory data from Easyflor into our data warehouse, enabling real-time business intelligence."]`

### I.B. Detailed Goals & Success Metrics

* **Primary Goals:** `[List 3-5 primary, specific, measurable, achievable, relevant, and time-bound (SMART) goals for this project. What must it achieve to be considered successful? Examples: "Successfully process 100% of daily sales orders within 5 minutes of creation," "Reduce data pipeline errors by 90% compared to the old system," "Achieve user adoption by 80% of the sales team within 3 months of launch."]`
* **Key Success Metrics:** `[How will you measure the achievement of these goals? What are the Key Performance Indicators (KPIs)? Examples: "Order processing latency," "Data error rate," "User satisfaction score (NPS)," "System uptime."]`
* **Non-Goals (Out of Scope):** `[Explicitly state what this project will NOT do. This is crucial for scope management. Examples: "This project will not handle customer relationship management (CRM) features," "User interface development is out of scope for the API MVP."]`

### I.C. Target Users & Stakeholders

* **Primary Users:** `[Who are the primary users of the system/output of this project? Describe their roles and how they will interact with it. Examples: "Data Analysts using BI tools on the transformed data," "Backend services consuming the API."]`
* **Key Stakeholders:** `[Who are the key stakeholders (non-users who have a vested interest)? Examples: "Head of Sales (sponsor)," "IT Operations Team (for deployment/maintenance)," "Compliance Officer."]`

## II. Technical Specifications & Architecture

### II.A. Core Technology Stack

* **Primary Language(s) & Version(s):** `[e.g., Go 1.23+, Python 3.10+]`
* **Key Frameworks/Libraries:** `[e.g., Gin (Go), Fiber (Go), standard library, specific SDKs like google-cloud-go, Cobra (CLI)]`
* **Databases/Storage:** `[e.g., PostgreSQL 15, Google Cloud Storage, BigQuery, Redis]`
* **Cloud Platform & Key Services:** `[e.g., Google Cloud Platform (GCP) - Cloud Run, Cloud Functions, Pub/Sub, Vertex AI]`
* **Key Development Tools:** `[e.g., Firebase Studio, Docker, Git, GoLand, VS Code]`
* **CI/CD Pipeline (if known):** `[e.g., GitHub Actions, Jenkins, Cloud Build]`

### II.B. High-Level Architectural Overview

* `[Provide a brief description of the intended architecture. Is it monolithic, microservices, serverless, event-driven? What are the major components and how do they interact? A simple diagram or link to one (if available) can be very helpful here if you can describe it to the AI.]`
* **Key Architectural Principles/Patterns being followed:** `[e.g., Hexagonal Architecture, Clean Architecture, RESTful APIs, Idempotency, Domain-Driven Design concepts]`

### II.C. Data Model & Key Entities (If Applicable)

* `[Describe the main data entities the system will handle. What are their key attributes and relationships? For an API, what are the main resources? Examples: "SalesOrder (ID, CustomerID, OrderDate, Items[])," "Product (ID, Name, Price, StockQuantity)."]`

### II.D. External System Integrations

* `[List all external systems this project will integrate with. For each, specify:
  * System Name: e.g., Easyflor ERP
  * Integration Purpose: e.g., Source of sales orders and product data
  * Integration Method: e.g., REST API (provide link to its docs if AI should know them), Message Queue, Database Link, File Transfer
  * Authentication: e.g., OAuth2, API Key
  * Key Data Points Exchanged: e.g., New/updated sales orders, product stock levels
    ]`

## III. AI Collaboration Guidelines (Project-Specific)

### III.A. Project-Specific AI Sub-Persona

* **Desired AI Persona Name/Focus for THIS project:** `[Give the AI a specific role for this project. Examples: "Go ELT API Specialist," "ContextVibes CLI Feature Developer AI," "Dataform Standardization Expert." This helps the AI tailor its responses.]`
* **Key Responsibilities for AI in this project:** `[What are the primary tasks you expect the AI to help with? Examples: "Generating Go boilerplate code for API handlers and service logic," "Writing unit and integration tests," "Drafting Dataform SQLX queries," "Refactoring code for performance," "Explaining complex SDK usage," "Assisting with Dockerfile creation."]`

### III.B. Critical Project-Specific Rules & Standards (Overrides/extends core airules.md)

* **Formatting/Linting (if different from gofmt):** `[Specify if any additional linters or formatters are used and their key rules.]`
* **Naming Conventions (if specific beyond general Go):** `[e.g., "All API endpoint handlers must be prefixed with 'handle' and suffixed with the HTTP method, e.g., handleGetSalesOrders."]`
* **Error Handling Strategy (if specific patterns are mandated):** `[e.g., "All errors returned from service layers must be wrapped with custom error types defined in 'pkg/errors'. Provide examples if complex."]`
* **Logging Strategy (if specific fields/formats are required beyond slog defaults):** `[e.g., "All log messages must include 'trace_id' and 'user_id' if available in context."]`
* **Testing Philosophy & Requirements:** `[e.g., "All public functions must have unit tests with >80% coverage." "Integration tests are required for all API endpoints." "Use testify/assert and testify/mock."]`
* **API Design Standards (if applicable):** `[e.g., "Follow OpenAPI 3.0 spec." "All POST requests must return 201 on success." "Use snake_case for JSON request/response bodies."]`
* **Security Considerations/Rules (Key ones for AI to be aware of):** `[e.g., "Never log raw API keys or PII." "All user input must be validated using the 'validator' package before processing." "Be mindful of SQL injection risks when generating database query helpers." Refer to`Guardian`for detailed security reviews.]`
* **Specific Libraries/SDKs to Prefer (or Avoid):** `[e.g., "Prefer using the official 'google-cloud-go' SDK over direct HTTP calls to GCP services." "Avoid using deprecated library X."]`
* **Directory Structure Conventions (if specific):** `[Briefly describe the expected layout, e.g., Go Project Layout (Standard), or link to internal docs.]`

### III.C. Key Code Examples or Snippets (Illustrative of desired patterns)

* `[If there are very specific, non-obvious coding patterns or boilerplate you want the AI to follow, provide a small, clear example here. This is especially useful for complex setup or unique internal library usage. Keep it concise.]`

    ```go
    // Example of a preferred service method structure:
    // func (s *myService) ProcessThing(ctx context.Context, itemID string) (*ThingResponse, error) {
    //     s.logger.InfoContext(ctx, "starting to process thing", "item_id", itemID)
    //     // ... validation ...
    //     // ... business logic ...
    //     // ... error handling ...
    //     return &ThingResponse{...}, nil
    // }
    ```

## IV. Project Roadmap & Current Focus (High-Level)

### IV.A. Overall Project Phases/Milestones

* `[List major phases or milestones if known. Example: "Phase 1: MVP API for Sales Orders & Inventory (Target: YYYY-MM-DD)." "Phase 2: Add Customer Data Sync." "Phase 3: Production Hardening."]`

### IV.B. Current Sprint/Iteration Goal (If applicable using Agile)

* `[What is the primary goal of the current development cycle/sprint? This gives the AI immediate context on what you're working on RIGHT NOW. Example: "Implement CRUD endpoints for Sales Orders."]`

### IV.C. Immediate Next Steps / Focus Areas for AI Assistance

* `[What are the very next 1-3 tasks where you anticipate needing AI help? Be specific. Example: "Draft the Go struct for SalesOrder based on API spec." "Generate a Gin handler for POST /salesorders." "Write unit tests for the sales order creation service."]`

## V. Key Project Team Members (Conceptual Personas)

* **Project Owner/Lead:** `[e.g., Orion]`
* **Scrum Master (if applicable):** `[e.g., Helms]`
* **Lead Developer(s):** `[e.g., Bolt, Orion]`
* **Security Lead:** `[e.g., Guardian]`
* **Technical Writer/Doc Lead:** `[e.g., Scribe]`
* **QA Lead:** `[e.g., QA-Bot]`
* **Other Key Roles:** `[e.g., Sparky (Dev Environment), Kernel (Tooling/Automation), Nexus (ContextVibes Liaison)]`

---
*This document should be regularly reviewed and updated by the Project Lead.*

# Development Guidelines for Go

## Core Philosophy

**TEST-DRIVEN DEVELOPMENT IS NON-NEGOTIABLE.** Every single line of production code must be written in response to a failing test. No exceptions. This is not a suggestion or a preference—it is the fundamental practice that enables all other principles in this document.

Follow a strict Test-Driven Development (TDD) methodology, with a strong emphasis on behavior-driven principles and idiomatic Go patterns. All work must be done in small, incremental changes that maintain a working, test-passing state throughout development.

## Quick Reference

**Key Principles:**

*   Write tests first (TDD: Red-Green-Refactor).
*   Test behavior, not implementation, using blackbox packages (package myapp_test).
*   Use table-driven tests for comprehensive behavioral coverage.
*   Achieve immutability through patterns (pass-by-value or unexported fields with getters).
*   Write small, pure functions.
*   Use golangci-lint with a strict, shared configuration.
*   Depend on interfaces, not concrete types.
*   Handle all errors explicitly; never ignore an error return.
*   Use go-playground/validator with struct tags for data validation.

**Preferred Tools:**

*   **Language**: Go
*   **Testing**: Standard `testing` package, `github.com/stretchr/testify/assert` & `require`.
*   **Mocking**: `go.uber.org/mock` (gomock) with `mockgen`.
*   **HTTP Testing**: Standard `net/http/httptest` package.
*   **Linting**: `golangci-lint`.
*   **Validation**: `github.com/go-playground/validator`.

## Testing Principles

### Behavior-Driven Testing

*   **No "Unit Tests" in Name Only**: The term is not helpful. Tests must verify observable business behavior, treating the package's implementation as a black box.
*   **Test Through the Public API Exclusively**: All tests verifying behavior must be in a `_test` package (e.g., `package orders_test`) to ensure they can only access exported identifiers. This is a compiler-enforced rule.
*   **No 1:1 Mapping Between Test and Implementation Files**: A single `*_test.go` file should contain all behavioral tests for a related set of features, often corresponding to a single public function or struct. For example, `order_processor_test.go` tests the behavior of the `ProcessOrder` function.
*   **Table-Driven Tests are the Standard**: Use table-driven tests with `t.Run` for subtests as the default pattern. Each row in the table represents a specific behavior or scenario to be tested.
*   **Coverage Targets**: 100% statement coverage is the goal, but these tests must **ALWAYS** be based on business behavior, not implementation details. Tests that exist only to increase a coverage number without verifying a meaningful behavior are wasteful.
*   **Tests as Documentation**: Tests must document expected business behavior through descriptive names (e.g., `TestProcessOrder/should_apply_free_shipping_for_orders_over_50`).

### Test Organization

Tests should be organized by feature, not by file structure. A single test file should cover the behavior of a public API, even if that API's implementation is spread across multiple (unexported) files.

```
src/
  features/
    payment/
      payment_processor.go
      payment_validator.go  // unexported implementation detail
      payment_processor_test.go // In 'package payment_test'
                                // Tests all behavior of the payment processor,
                                // which implicitly covers the validator's logic.
```

### Test Data Factory Pattern

Use factory functions with the Functional Options Pattern for creating test data. This provides clear, reusable, and overridable test fixtures.

```go
package testhelpers

// Define the option function type
type PaymentRequestOption func(*PostPaymentsRequest)

// Define option-setting functions
func WithAmount(amount int) PaymentRequestOption {
    return func(req *PostPaymentsRequest) {
        req.Amount = amount
    }
}

func WithSource(source string) PaymentRequestOption {
    return func(req *PostPaymentsRequest) {
        req.Source = source
    }
}

// The factory function
func NewMockPaymentRequest(opts ...PaymentRequestOption) *PostPaymentsRequest {
    // 1. Create with sensible defaults
    req := &PostPaymentsRequest{
        CardAccountId: "1234567890123456",
        Amount:        100,
        Source:        "Web",
        Address:       NewMockAddress(),
    }

    // 2. Apply overrides
    for _, opt := range opts {
        opt(req)
    }
    return req
}

func NewMockAddress() *Address {
    return &Address{ /*... defaults... */ }
}
```

**Key Principles for Factories:**

*   Always return a complete, valid object with sensible defaults.
*   Use the Functional Options Pattern for overrides.
*   Compose factories for complex, nested objects.

## Go Language Guidelines

### Type Definitions and Data Validation

*   **`struct` for Data, `interface` for Behavior**: This is a fundamental distinction. Use structs to define the shape of your data. Use interfaces to define the methods a dependency must provide.
*   **Accept Interfaces, Return Structs**: Functions should accept interfaces as parameters to allow for flexibility and mocking. They should return concrete struct types to give the caller maximum utility.
*   **Domain-Specific Types**: Use `type` definitions to create distinct types for domain-specific identifiers (e.g., `type UserID string`). This provides compile-time safety against mixing different kinds of IDs.
*   **Schema-First with Struct Tags**: Define data shapes as structs. Use struct tags with the `go-playground/validator` library for runtime validation. This is the idiomatic alternative to Zod.

```go
package models

// The struct is the single source of truth for shape and validation rules.
type CreatePaymentRequest struct {
    CardAccountID string `json:"cardAccountId" validate:"required,len=16"`
    Amount        int    `json:"amount" validate:"required,gt=0"`
    Source        string `json:"source" validate:"required,oneof=Web Mobile API"`
    Brand         string `json:"brand" validate:"required,oneof=Visa Mastercard Amex"`
}
```

*   **Use Real Types in Tests**: Tests **must** import and use the real struct definitions from the application code. Never redefine a struct in a test file. Test data factories must return instances of the real struct types.

### Code Style

*   **Functional Principles**:
    *   **Immutability**: Strive for immutability. For shared data structures, use unexported fields with getter methods that return copies of slices and maps.
    *   **Pure Functions**: Write pure functions (no side effects) wherever possible.
    *   **Composition over Inheritance**: Build complex types by embedding simpler structs. Use interfaces to achieve polymorphism.
    *   **Prefer `for` loops**: Use standard `for...range` loops for iteration. Avoid overly complex generic abstractions for simple collection operations.
*   **Code Structure**:
    *   **Guard Clauses / Early Returns**: Use the `if err != nil { return err }` pattern to handle errors at the beginning of a function. This keeps the "happy path" at the lowest indentation level and eliminates nested `if/else` statements.
    *   **Small Functions**: Keep functions small and focused on a single responsibility.
    *   **Functional Options Pattern**: Use the Functional Options Pattern for constructors or functions with multiple (especially optional) parameters. This is the idiomatic replacement for configuration objects or long parameter lists.
*   **Naming Conventions**: Follow Go's standard naming conventions strictly.
    *   **Packages**: `lowercase`, `singleword`.
    *   **Identifiers**: `MixedCaps` for exported, `mixedCaps` for unexported.
    *   **Files**: `snake_case.go` and `snake_case_test.go`.
    *   **Getters**: No `Get` prefix. The getter for a field `userID` is `UserID()`.
*   **Documentation with `godoc`**:
    *   **Comments are Mandatory for Public APIs**: The "no comments" rule is an anti-pattern in Go.
    *   Every exported function, type, constant, and package **must** have a clear `godoc` comment explaining its purpose and usage.
    *   Comments must be complete sentences. A comment for package `foo` begins `// Package foo...`. A comment for `func Bar` begins `// Bar...`.
    *   Documentation is a required part of every feature delivery.

### Error Handling

*   **Explicit Error Returns**: Functions that can fail **must** return an `error` as their last return value.
*   **Check Every Error**: The result of a function that returns an error must not be used until the error has been checked and is `nil`.
*   **Error Wrapping**: Add context to errors by wrapping them with `fmt.Errorf` and the `%w` verb. This preserves the original error for programmatic inspection.
*   **Never `panic` for Handled Errors**: `panic` is for unrecoverable programmer errors, not for expected failures like invalid input or failed I/O. Servers and long-running applications must use `recover` to handle panics gracefully, log them as critical errors, and continue operation.

## Development Workflow

### TDD Process - THE FUNDAMENTAL PRACTICE

**CRITICAL**: TDD is not optional. Every feature, every bug fix, every change **MUST** follow this process:

1.  **Red**: Write a failing test for the desired behavior in a `*_test.go` file. The test must be specific and fail for the right reason. **NO PRODUCTION CODE** until you have a failing test.
2.  **Green**: Write the **MINIMUM** code necessary in the corresponding `*.go` file to make the test pass. Resist the urge to add any logic not explicitly required by the test.
3.  **Refactor**: With the safety of a passing test, assess the code. Clean up the implementation and the test code, remove duplication, improve names, and extract helper functions. Ensure all tests remain green.

**Common TDD Violations to Avoid:**

*   Writing production code without a failing test first.
*   Writing multiple tests before making the first one pass.
*   Writing more production code than needed to pass the current test.
*   Skipping the refactor assessment step.
*   Adding functionality "while you're there" without a test driving it.

**If you find yourself writing production code and there isn't a failing test demanding it, STOP immediately and write the test first.**

### Refactoring - The Critical Third Step

Refactoring is the key to maintaining code quality. After achieving a green state, you **MUST** assess whether the code can be improved.

*   **Commit Before Refactoring**: Always commit your working (green) code before starting a refactoring.
*   **Refactor Knowledge, Not Just Code**: DRY (Don't Repeat Yourself) is about canonical representations of **knowledge** and **business rules**. Do not abstract code that looks similar but represents different domain concepts. Duplicate code is far cheaper than the wrong abstraction.
*   **Use Interfaces to Decouple**: Introduce interfaces (preferably defined by the consumer) to break dependencies and allow for easier testing and replacement of components.
*   **Maintain Public APIs**: Refactoring changes the internal structure without changing the external, observable behavior. All tests must pass without modification.
*   **Commit Refactoring Separately**: Commit refactoring changes separately from feature changes with a `refactor:` prefix.

### Commit and Pull Request Standards

*   Use Conventional Commits (`feat:`, `fix:`, `refactor:`, etc.).
*   Each commit must be a complete, working unit (tests pass).
*   Pull Requests must be small, focused, and have all CI checks (test, lint) passing.
*   The PR description should explain the behavioral change, its business context, and any trade-offs considered.
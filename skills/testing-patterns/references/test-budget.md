# Test Budget

Source: https://thoughtbot.com/blog/introducing-test-budget

## Concept

Test Budget is a performance linter that prevents test suite slowness from being introduced incrementally. It monitors test execution times against configured budgets and flags violations.

## How It Works

1. Generate baseline from existing test runs
2. Set budgets per test type based on 99th percentile
3. Set suite-level budget at 10% above current total
4. Run audits after test runs to flag violations

## Budget Strategy

- **Suite-level budget**: 10% above current total, giving headroom for new tests
- **Per-test-type budgets**: Based on 99th percentile (slowest 1% of tests need fixing)
- **Allowlisting**: Temporary bypass for inherently slow operations with:
  - Reason documentation (why this test is slow)
  - Expiration date (forces re-evaluation)
  - Auto-fails when expired

## Principles

- Start with what you have, then improve.
- Don't bump the budget to accommodate slow tests permanently.
- Be aggressive — 10+ minute suites are unacceptable.
- Don't let allowlist entries quietly overstay their welcome.
- Wait time compounds: a slow suite makes every developer slower, every day.

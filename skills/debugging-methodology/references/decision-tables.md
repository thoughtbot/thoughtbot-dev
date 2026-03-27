# Decision Tables

Source: https://thoughtbot.com/blog/debugging-listing-your-assumptions

## What Is a Decision Table?

A systematic listing of all input combinations mapped to their expected and actual outputs. It turns "this doesn't work" into "specifically, given X, I expected Y but got Z."

## Format

```
| Input 1 | Input 2 | Expected Output | Actual Output | Match? |
|---------|---------|----------------|---------------|--------|
| valid   | valid   | success        | success       | ✓      |
| valid   | nil     | error message  | crash         | ✗      |
| nil     | valid   | error message  | nil           | ✗      |
| nil     | nil     | error message  | crash         | ✗      |
```

## Boundary Values to Always Include

For strings: `nil`, `""`, `" "` (whitespace), very long strings, strings with special characters
For numbers: `nil`, `0`, `-1`, `Float::INFINITY`, `Float::NAN`, max integer
For arrays: `nil`, `[]`, single element, many elements
For dates: `nil`, today, past, future, timezone boundaries, DST transitions
For booleans: `true`, `false`, `nil`

## How to Use

1. List the inputs to the method or feature under test.
2. Create one row per combination — start with the happy path.
3. Add boundary values for each input.
4. Fill in "Expected Output" from the spec or your understanding.
5. Fill in "Actual Output" by running the code.
6. Every "✗" row is either a bug or a spec gap.

## What Decision Tables Reveal

- **Implementation bugs**: Actual != Expected for valid inputs
- **Missing validation**: Crashes on nil/empty instead of error messages
- **Spec gaps**: "What SHOULD happen here?" — nobody decided
- **Redundant tests**: Multiple rows testing the same code path

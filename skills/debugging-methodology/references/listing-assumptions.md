# Listing Your Assumptions

Source: https://thoughtbot.com/blog/debugging-listing-your-assumptions

## Why This Works

Computers do exactly what we tell them. Bugs are miscommunicated instructions. The miscommunication usually comes from false assumptions we don't know we're making.

## Technique 1: Write a List

Literally write down every assumption you believe is true:

- "The user is always signed in when they reach this page"
- "This method always returns an array"
- "The email is sent after the record is saved"
- "Inventory count is always >= 0"
- "Timezones are 1-hour intervals" (they're not — some are 30 or 45 minutes)

The act of writing forces implicit knowledge into explicit statements. Some bugs resolve the moment you state the assumption out loud.

## Technique 2: Pair With Someone

Your pair partner has different implicit assumptions. When you explain the situation:

- You surface assumptions you didn't know you had
- Their questions force you to justify beliefs you took for granted
- Different mental models clash, producing explicit statements
- "Unknown unknowns" become visible through their fresh perspective

You don't need a senior developer — any thoughtful listener works. The value is in the explaining, not the expertise.

## Technique 3: Decision Tables

Systematically enumerate all input combinations:

```
| first_name | last_name | full_name     | Expected? |
|------------|-----------|---------------|-----------|
| "Ada"      | "Lovelace"| "Ada Lovelace"| ✓         |
| nil        | "Lovelace"| " Lovelace"   | ✗ — leading space |
| "Ada"      | nil       | "Ada "        | ✗ — trailing space |
| nil        | nil       | " "           | ✗ — just a space |
```

Decision tables reveal:
- Implementation bugs (nil handling)
- Specification gaps (what SHOULD nil do?)
- Boundary conditions nobody considered

## Technique 4: Diagram It

Draw the relationships between entities:

- Entity-relationship diagrams surface missing tables or joins
- Sequence diagrams surface ordering assumptions
- State diagrams surface impossible transitions

Switching to a visual medium provides a different perspective on the same problem.

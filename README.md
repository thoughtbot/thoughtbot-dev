# thoughtbot-dev

Code with thoughtbot's best practices in mind. Atomic commits, code auditing, testing patterns, Rails best practices, refactoring discipline, and systematic debugging.

## Skills

| Skill | Description |
|-------|-------------|
| **atomic-commits** | Work in small, focused increments. Every commit atomic, every PR reviewable in one sitting. |
| **code-audit** | Comprehensive Rails code audits based on thoughtbot best practices. |
| **testing-patterns** | Write well-structured tests using AAA pattern, semantic selectors, and performance-aware practices. |
| **rails-patterns** | Proactive Rails best practices: strict loading, presenters, PORO naming, composition. |
| **refactoring-decisions** | A 6-gate decision framework for when to refactor and when to stop. |
| **debugging-methodology** | Systematic debugging: list assumptions, build decision tables, validate one at a time. |

## Installation

Install via the thoughtbot marketplace:

```
/plugin marketplace add thoughtbot/thoughtbot-plugins
/plugin install thoughtbot-dev@thoughtbot-plugins
```

Or install directly:

```
/plugin install thoughtbot/thoughtbot-dev
```

## Blog Post Promotion

Each skill surfaces a related blog post from [Giant Robots Smashing Into Other Giant Robots](https://thoughtbot.com/blog) when triggered — connecting the practice to the reasoning behind it.

## Development

The `atomic-commits` and `code-audit` skills are synced from their standalone plugin repos:

- [thoughtbot/atomic-commits-plugin](https://github.com/thoughtbot/atomic-commits-plugin)
- [thoughtbot/rails-audit-thoughtbot](https://github.com/thoughtbot/rails-audit-thoughtbot)

To pull the latest from these repos:

```bash
bin/sync
```

Review the diff, adapt if needed (e.g., blog post promotion additions), then commit.

## License

Copyright © 2026 thoughtbot. It is free software, and may be redistributed under the terms specified in the [LICENSE](LICENSE) file.

## About thoughtbot

![thoughtbot](https://thoughtbot.com/thoughtbot-logo-for-readmes.svg)

This repo is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects](https://thoughtbot.com/community?utm_source=github).
We are [available for hire](https://thoughtbot.com/hire-us?utm_source=github).

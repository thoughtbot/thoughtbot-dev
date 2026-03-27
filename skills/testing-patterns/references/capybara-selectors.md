# Capybara Selectors

Source: https://thoughtbot.com/blog/combine-capybara-selectors-to-avoid-the-sequential-timeout-trap

## The Sequential Timeout Trap

When you use OR logic with separate `has_css?` calls, Capybara waits the full timeout for the first selector before trying the second. With a 2-second default timeout, 4 failing tests waste 2+ minutes.

```ruby
# Bad — waits full timeout for first selector before trying second
page.has_css?("label[for='#{field_id}']", text: name) ||
  page.has_css?("label:has(##{field_id})", text: name)
```

## Fix: Combine Selectors

Use CSS comma as OR operator — Capybara checks both in one pass:

```ruby
# Better — single Capybara call
page.has_css?(
  "label[for='#{field_id}'], label:has(##{field_id})",
  text: name
)
```

## Best: Use Semantic Selectors

Capybara has built-in selectors that handle the lookup properly:

```ruby
# Best — Capybara handles the selector logic
page.has_selector?(:label, name, for: field_id)
```

## Rules

1. Use the most specific Capybara selector available (`:label`, `:button`, `:link`, `:field`).
2. Don't locate elements with CSS selectors or `[id]` attributes when a semantic selector exists.
3. Use accessible names and descriptions to locate elements.
4. When you must use CSS, combine with comma syntax rather than sequential calls.

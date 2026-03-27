# Arrange/Act/Assert Pattern

Source: https://thoughtbot.com/blog/the-arrange-act-assert-pattern

## The Pattern

Every test follows three steps:
1. **Arrange** — setup objects, database, or anything else
2. **Act** — exercise the system under test
3. **Assert** — verify the result

Separate each step with a blank line.

## Problem: Expectations Mixed Into Arrange

```ruby
# Bad — expectation set up in Arrange, unclear what's being tested
it "logs the tag being added" do
  tag = create(:tag)
  expect(Rails.logger).to receive(:info).with("added #{tag.name}")
  user = create(:user, tags: [])
  user.add_tag(tag)
end

# Good — clear separation
it "logs the tag being added" do
  tag = create(:tag)
  allow(Rails.logger).to receive(:info)
  user = create(:user, tags: [])

  user.add_tag(tag)

  expect(Rails.logger).to have_received(:info)
    .with("added #{tag.name}")
end
```

Key: Use `allow` in Arrange to set up stubs. Use `expect(...).to have_received` in Assert to verify.

## Problem: `let` and `before` Hide Setup

```ruby
# Bad — setup scattered across file, hard to trace
let(:user) { create(:user) }
let(:tag) { create(:tag) }
before { user.tags = [] }

it "adds the tag" do
  user.add_tag(tag)
  expect(user.tags).to eq([tag])
end
```

```ruby
# Good — all preconditions visible in the test
it "adds the tag" do
  user = create(:user, tags: [])
  tag = create(:tag)

  user.add_tag(tag)

  expect(user.tags).to eq([tag])
end
```

Developer time is the scarcest resource. Inline setup means you never have to scan the entire file to understand a single test.

## Problem: Multiple Actions in One Test

Each test should exercise one action. If you need to test a sequence, write separate tests for each step.

```ruby
# Bad — two actions, unclear which caused the result
it "processes the order" do
  order = create(:order)
  order.validate!
  order.submit!
  expect(order.status).to eq("submitted")
end

# Good — one action per test
it "validates the order" do
  order = create(:order)

  order.validate!

  expect(order).to be_valid
end

it "submits a validated order" do
  order = create(:order, validated: true)

  order.submit!

  expect(order.status).to eq("submitted")
end
```

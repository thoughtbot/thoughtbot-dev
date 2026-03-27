# Strict Loading in Rails

Source: https://thoughtbot.com/blog/strict-loading-in-rails-8-a-railsy-way-to-avoid-n-1-queries

## Configuration Levels

### Model-level (recommended for new models)

```ruby
class Article < ApplicationRecord
  self.strict_loading_by_default = true
end
```

### Association-level (for targeted enforcement)

```ruby
class Author < ApplicationRecord
  has_many :articles, strict_loading: true
end
```

### Global mode configuration

In `config/environments/development.rb`:

```ruby
# :all — raises on any lazy loading (strict)
# :n_plus_one_only — only raises for actual N+1 problems (recommended for dev)
config.active_record.strict_loading_mode = :n_plus_one_only
```

### Production safety

In `config/environments/production.rb`:

```ruby
# Log instead of raising to prevent crashes
config.active_record.action_on_strict_loading_violation = :log
```

### Console override

```ruby
# config/application.rb
console do
  ActiveRecord::Base.strict_loading_by_default = false
end
```

## FactoryBot Bypass

Strict loading can interfere with test factories. Bypass it:

```ruby
# spec/support/factory_bot.rb
FactoryBot::SyntaxMethods.module_eval do
  def after_build_and_stub(factory)
    after(:build) { |record| record.strict_loading!(false) }
    after(:stub) { |record| record.strict_loading!(false) }
  end
end
```

Or per-factory:

```ruby
FactoryBot.define do
  factory :article do
    title { "Test Article" }

    after(:build) { |article| article.strict_loading!(false) }
    after(:stub) { |article| article.strict_loading!(false) }
  end
end
```

## Resolving Violations

```ruby
# Violation — lazy loads comments
Article.all.each { |a| a.comments.count }

# Fix — eager load
Article.includes(:comments).each { |a| a.comments.count }

# Or preload (always separate query, never joins)
Article.preload(:comments).each { |a| a.comments.count }
```

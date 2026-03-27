# PORO Naming and Composition

Source: https://thoughtbot.com/blog/audit-using-thoughtbot-best-practices-with-claude-skills

## The Problem with Service Objects

"Service Object" is a catch-all name that obscures what the object actually represents. `*Service`, `*Manager`, `*Handler` suffixes tell you nothing about the domain.

## Name After What It IS

```ruby
# Bad — what does this "service" represent?
class UserCreationService; end
class OrderProcessingManager; end
class PaymentHandler; end

# Good — these are domain concepts
class Registration; end
class Checkout; end
class Payment; end
```

## Use ActiveModel::Model

For domain objects that don't persist to a database but need validations and form integration:

```ruby
class Registration
  include ActiveModel::Model

  attr_accessor :email, :password, :company_name

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }
  validates :company_name, presence: true

  def complete
    return false unless valid?
    user = User.create!(email: email, password: password)
    Company.create!(name: company_name, owner: user)
    RegistrationMailer.welcome(user).deliver_later
    true
  end
end
```

This works with Rails form helpers, validations, and error display — just like an ActiveRecord model.

## Composition Over Modules

For organizing logic within a single class, prefer composition (injected collaborators) over modules (mixins):

```ruby
# Less clear — where does `send_notification` come from?
class Checkout
  include Notifiable
  include Billable
end

# Clearer — explicit dependencies
class Checkout
  def initialize(notifier: SlackNotifier.new, billing: StripeBilling.new)
    @notifier = notifier
    @billing = billing
  end

  def complete(order)
    @billing.charge(order)
    @notifier.notify("Order #{order.id} completed")
  end
end
```

Composition makes dependencies explicit, testable (inject doubles), and avoids module method collisions.

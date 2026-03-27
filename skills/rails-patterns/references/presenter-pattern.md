# Presenter Pattern

Source: https://thoughtbot.com/blog/using-the-presenter-pattern-in-ruby-on-rails

## Structure

```ruby
# app/presenters/order_presenter.rb
class OrderPresenter
  def initialize(order)
    @order = order
  end

  def status_badge_class
    STATUS_CLASSES.fetch(@order.status, "badge-secondary")
  end

  def formatted_total
    "$#{'%.2f' % @order.total}"
  end

  def delivery_estimate
    if @order.express?
      "1-2 business days"
    else
      "5-7 business days"
    end
  end

  private

  STATUS_CLASSES = {
    "paid" => "badge-success",
    "pending" => "badge-warning",
    "cancelled" => "badge-danger"
  }.freeze
end
```

## Usage

```ruby
# Controller
def show
  @order = Order.find(params[:id])
  @presenter = OrderPresenter.new(@order)
end
```

```erb
<!-- View -->
<span class="<%= @presenter.status_badge_class %>">
  <%= @order.status %>
</span>
<p>Total: <%= @presenter.formatted_total %></p>
```

## Testing

Test presenters as plain Ruby objects — no database needed for formatting logic:

```ruby
RSpec.describe OrderPresenter do
  it "returns the correct badge class for paid orders" do
    order = instance_double(Order, status: "paid")
    presenter = OrderPresenter.new(order)

    result = presenter.status_badge_class

    expect(result).to eq("badge-success")
  end
end
```

## When to Use What

| Approach | Best For |
|----------|----------|
| **Presenter** | Reusable view logic, multiple views, complex formatting, testable |
| **Helper** | Simple one-off formatting (date formatting, single-method utilities) |
| **ViewComponent** | Reusable UI with both logic AND markup (buttons, cards, etc.) |

Avoid creating a presenter for simple formatting that a helper can handle. Don't over-engineer.

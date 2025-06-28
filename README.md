# PlainParams

A lightweight Ruby gem for parameter validation and organization using ActiveModel, without the overhead of ActiveRecord or complex validation libraries.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'plain_params'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install plain_params
```

## Overview

PlainParams provides a simple way to handle parameter validation by dividing attributes into two categories:

- **Real fields**: Required attributes with automatic presence validation
- **Virtual fields**: Optional computed attributes that can depend on real fields

## Basic Usage

### Simple Example

```ruby
class UserParams < PlainParams
  @real_fields = %i[name email]
  @virtual_fields = %i[display_name]

  def display_name
    name.upcase if name
  end
end

# Create instance with parameters
params = UserParams.new(name: "john", email: "john@example.com")

# Access attributes
params.name         # => "john"
params.email        # => "john@example.com"
params.display_name # => "JOHN"

# Check validity
params.valid?       # => true

# Get all values
params.values
# => {
#      real: { name: "john", email: "john@example.com" },
#      virtual: { display_name: "JOHN" }
#    }
```

### Validation Example

```ruby
class ProductParams < PlainParams
  @real_fields = %i[name price quantity]
  @virtual_fields = %i[total_value in_stock]

  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  def total_value
    price * quantity if price && quantity
  end

  def in_stock
    quantity && quantity > 0
  end
end

# Invalid parameters
params = ProductParams.new(name: "Widget", price: -10)
params.valid?  # => false
params.errors.full_messages
# => ["Price must be greater than 0", "Quantity can't be blank"]
```

### Advanced Example with Dependencies

```ruby
class OrderParams < PlainParams
  @real_fields = %i[customer_id items_count discount_percentage]
  @virtual_fields = %i[has_discount order_size discount_multiplier]

  validates :items_count, numericality: { greater_than: 0 }
  validates :discount_percentage, numericality: { 
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100 
  }

  def has_discount
    discount_percentage && discount_percentage > 0
  end

  def order_size
    return :small if items_count <= 5
    return :medium if items_count <= 20
    :large
  end

  def discount_multiplier
    1 - (discount_percentage.to_f / 100)
  end
end

params = OrderParams.new(
  customer_id: 123,
  items_count: 10,
  discount_percentage: 15
)

params.order_size         # => :medium
params.has_discount       # => true
params.discount_multiplier # => 0.85
```

## Features

### ActiveModel Integration

PlainParams integrates seamlessly with ActiveModel, providing:

- Full validation support
- Attribute naming conventions
- Error handling
- Form helper compatibility

### String Key Support

Parameters can be passed with either symbol or string keys:

```ruby
# Both work identically
UserParams.new(name: "john", age: 30)
UserParams.new("name" => "john", "age" => 30)
```

### Error Handling

PlainParams provides clear error messages for common issues:

```ruby
# Missing field definitions
class EmptyParams < PlainParams
end
EmptyParams.new  # => RuntimeError: No @real_fields or @virtual_fields provided

# Duplicate fields
class DuplicateParams < PlainParams
  @real_fields = %i[name]
  @virtual_fields = %i[name]
end
DuplicateParams.new  # => RuntimeError: Duplicated field(s) 'name'

# Invalid fields
UserParams.new(invalid: "value")  # => RuntimeError: field 'invalid' is not in @real_fields or @virtual_fields
```

## API Reference

### Class Methods

- `real_fields` - Returns array of real field names
- `virtual_fields` - Returns array of virtual field names

### Instance Methods

- `values` - Returns hash with all real and virtual values
- `real_values` - Returns hash with only real field values
- `virtual_values` - Returns hash with only virtual field values
- `valid?` - Validates the instance according to defined validations
- `persisted?` - Always returns `false` (ActiveModel compatibility)

## Best Practices

1. **Keep virtual fields simple** - They should contain display logic or simple calculations
2. **Use real fields for validation** - Put your validation rules on real fields
3. **Leverage ActiveModel validations** - Use the full power of ActiveModel validations
4. **Virtual fields for computed values** - Use virtual fields for values derived from real fields

## Requirements

- Ruby >= 3.0
- ActiveModel >= 7.0, < 9.0

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gedean/plain_params.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

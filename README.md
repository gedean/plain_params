# PlainParams Documentation

## General Description

The `PlainParams` class is a Ruby utility that leverages the ActiveModel library to provide a parameter handling model divided into real fields (`real_fields`) and virtual fields (`virtual_fields`).

This class is designed to validate and organize the received parameters, splitting them into real and virtual attributes. Real fields are required and must adhere to pre-defined validations, while virtual fields allow additional manipulations based on the real fields.

> **Note**: The `PlainParams` class should not be instantiated directly. It is intended to be subclassed.

---

## Class Structure

### Dependencies

- **`ActiveModel::Naming`**: Provides helper methods related to the model's name.
- **`ActiveModel::Conversion`**: Adds methods for converting the model into different formats.
- **`ActiveModel::Validations`**: Adds support for attribute validation.

### Class Attributes

- **`@real_fields`**: List of mandatory real fields.
- **`@virtual_fields`**: List of optional virtual fields.

---

## Methods

### `initialize(params_attributes = {})`

Constructor that initializes the class with the provided attributes.

- Checks if `@real_fields` and `@virtual_fields` are defined.
- Configures attributes based on the provided parameters.
- Raises an error if fields in `params_attributes` are not present in `@real_fields` or `@virtual_fields`.

### `self.real_fields` and `self.virtual_fields`

Getters to access `@real_fields` and `@virtual_fields`.

### `self.real_fields=(value)` and `self.virtual_fields=(value)`

Setters to define the values of `@real_fields` and `@virtual_fields`.

### `values`

Returns a hash containing the values of real and virtual fields:

```ruby
{
  real: { real_field: value },
  virtual: { virtual_field: value }
}
```

### `real_values` and `virtual_values`

Helper methods that return the values of `real_fields` and `virtual_fields`, respectively.

### `persisted?`

Returns `false`, indicating that the model is not persisted.

---

## Private Methods

### `attributes=(attributes)`

Method that assigns values to real and virtual attributes:

- Checks for duplicate fields between `@real_fields` and `@virtual_fields`.
- Raises errors if invalid fields are provided.
- Initializes real fields first and then virtual fields, allowing interdependencies between them.

---

## Example Usage

### Subclassing PlainParams

The `PlainParams` class must be subclassed to define specific real and virtual fields. Below is an example:

```ruby
class Params < PlainParams
  @real_fields = %i[name age]
end
```

### Using a Custom Subclass

```ruby
class MyParams < PlainParams
  @real_fields = [:name, :age]
  @virtual_fields = [:age_in_days]

  def age_in_days
    age * 365 if age
  end
end

params = MyParams.new(name: "John", age: 30)
puts params.real_values   # => { name: "John", age: 30 }
puts params.virtual_values # => { age_in_days: 10950 }
```

---

## Notes

1. It is mandatory to define `@real_fields` and/or `@virtual_fields` in the class inheriting from `PlainParams`.
2. Duplicate fields between `@real_fields` and `@virtual_fields` will raise an initialization error.
3. Presence validation is automatically applied to `real_fields`.

This structure provides a robust foundation for parameter handling in Ruby applications, ensuring proper organization and validation.

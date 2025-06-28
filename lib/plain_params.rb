require 'active_model'

class PlainParams
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  def initialize(params_attributes = {})
    raise 'No @real_fields or @virtual_fields provided in the class definition' if self.class.real_fields.nil? && self.class.virtual_fields.nil?

    self.class.real_fields ||= []
    self.class.virtual_fields ||= []

    setup_accessors
    self.attributes = params_attributes
  end

  class << self
    attr_accessor :real_fields, :virtual_fields
  end

  def values
    {
      real: self.class.real_fields.to_h { [it, send(it)] },
      virtual: self.class.virtual_fields.to_h { [it, send(it)] }
    }
  end
  
  def real_values = values[:real]
  def virtual_values = values[:virtual]
  def persisted? = false

  private
  
  def setup_accessors
    self.class.real_fields.each do |field|
      self.class.send(:attr_accessor, field)
      self.class.send(:validates_presence_of, field)
    end
    
    self.class.virtual_fields.each do |field|
      self.class.send(:attr_writer, field) unless self.class.method_defined?("#{field}=")
      self.class.send(:attr_reader, field) unless self.class.method_defined?(field)
    end
  end
    
  def attributes=(attributes)
    duplicated_fields = self.class.real_fields & self.class.virtual_fields
    raise "Duplicated field(s) '#{duplicated_fields.join(', ')}' in @real_fields and @virtual_fields" if duplicated_fields.any?

    symbolized_attributes = attributes.symbolize_keys
    invalid_fields = symbolized_attributes.keys - (self.class.real_fields + self.class.virtual_fields)
    
    invalid_fields.each do |invalid_field|
      raise "field '#{invalid_field}' is not in @real_fields or @virtual_fields"
    end

    initialize_real_fields(symbolized_attributes)
    initialize_virtual_fields(symbolized_attributes)
  end

  def initialize_real_fields(attributes)
    self.class.real_fields.each do |field|
      instance_variable_set("@#{field}", attributes[field])
    end
  end

  def initialize_virtual_fields(attributes)
    self.class.virtual_fields.each do |field|
      send("#{field}=", attributes[field]) if attributes.key?(field)
    end
  end
end

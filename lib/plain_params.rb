require 'active_model'

class PlainParams
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  def initialize(params_attributes = {})
    raise 'No @real_fields or @virtual_fields provided in the class definition' if (self.class.real_fields.nil? and self.class.virtual_fields.nil?)

    self.class.real_fields ||= []
    self.class.virtual_fields ||= []

    self.attributes = params_attributes
  end

  def self.real_fields = @real_fields
  def self.virtual_fields = @virtual_fields

  def values
    fields_values = {}

    fields_values[:real] = self.class.real_fields.map { |afield| [afield, send(afield)] }.to_h
    fields_values[:virtual] = self.class.virtual_fields.map { |afield| [afield, send(afield)] }.to_h

    fields_values
  end
  
  def real_values = values[:real]
  def virtual_values = values[:virtual]

  #def json_values = Oj.dump(values, mode: :compat)
  #def json_values = Oj.dump(values, mode: :compat)
  def persisted? = false

  private
    
  def attributes=(attributes)
    duplicated_fields = self.class.real_fields.intersection(self.class.virtual_fields)
    raise "Duplicated field(s) '#{duplicated_fields.join(', ')}' in @real_fields and @virtual_fields" if duplicated_fields.any?

    symbolized_attributes = attributes.symbolize_keys

    (symbolized_attributes.keys - (self.class.real_fields + self.class.virtual_fields)).each do |invalid_field|
      raise "field '#{invalid_field.to_s}' is not in @real_fields or @virtual_fields"
    end

    # initialized @real_fields first
    self.class.real_fields.each do |available_field|
      (instance_variable_set"@#{available_field.to_s}", symbolized_attributes[available_field])
      self.class.send(:attr_accessor, available_field)
      self.class.send(:validates_presence_of, available_field)
    end

    # @virtual_fields comes sencondly for use already initialized @available fields
    self.class.virtual_fields.each do |virtual_field|
      unless symbolized_attributes[virtual_field].nil?
        self.send("#{virtual_field.to_s}=", symbolized_attributes[virtual_field])
      end
    end
  end

  def self.real_fields=(value) 
    @real_fields = value
  end

  def self.virtual_fields=(value) 
    @virtual_fields = value
  end
end

require 'rspec'
require_relative '../lib/plain_params'

class TestParams < PlainParams
  @real_fields = %i[name age]
  @virtual_fields = %i[age_in_days full_description]

  def age_in_days
    age * 365 if age
  end

  def full_description
    "#{name} is #{age} years old" if name && age
  end
end

class InvalidParams < PlainParams
  @real_fields = %i[name duplicate_field]
  @virtual_fields = %i[duplicate_field other_field]
end

class EmptyParams < PlainParams
end

RSpec.describe PlainParams do
  describe '#initialize' do
    it 'creates instance with valid parameters' do
      params = TestParams.new(name: 'John', age: 30)
      expect(params).to be_valid
      expect(params.name).to eq('John')
      expect(params.age).to eq(30)
    end

    it 'raises error when no fields are defined' do
      expect { EmptyParams.new }.to raise_error(RuntimeError, 'No @real_fields or @virtual_fields provided in the class definition')
    end

    it 'raises error for duplicated fields' do
      expect { InvalidParams.new(name: 'John') }.to raise_error(RuntimeError, /Duplicated field\(s\) 'duplicate_field'/)
    end

    it 'raises error for invalid fields' do
      expect { TestParams.new(invalid_field: 'value') }.to raise_error(RuntimeError, "field 'invalid_field' is not in @real_fields or @virtual_fields")
    end

    it 'accepts string keys in parameters' do
      params = TestParams.new('name' => 'John', 'age' => 25)
      expect(params.name).to eq('John')
      expect(params.age).to eq(25)
    end
  end

  describe '#valid?' do
    it 'validates presence of real fields' do
      params = TestParams.new(name: 'John')
      expect(params).not_to be_valid
      expect(params.errors[:age]).to include("can't be blank")
    end

    it 'is valid when all real fields are present' do
      params = TestParams.new(name: 'John', age: 30)
      expect(params).to be_valid
    end
  end

  describe '#values' do
    let(:params) { TestParams.new(name: 'John', age: 30) }

    it 'returns hash with real and virtual values' do
      values = params.values
      expect(values[:real]).to eq(name: 'John', age: 30)
      expect(values[:virtual]).to eq(age_in_days: 10950, full_description: 'John is 30 years old')
    end
  end

  describe '#real_values' do
    it 'returns only real field values' do
      params = TestParams.new(name: 'John', age: 30)
      expect(params.real_values).to eq(name: 'John', age: 30)
    end
  end

  describe '#virtual_values' do
    it 'returns only virtual field values' do
      params = TestParams.new(name: 'John', age: 30)
      expect(params.virtual_values).to eq(age_in_days: 10950, full_description: 'John is 30 years old')
    end
  end

  describe '#persisted?' do
    it 'always returns false' do
      params = TestParams.new(name: 'John', age: 30)
      expect(params.persisted?).to be false
    end
  end

  describe 'virtual fields' do
    it 'can be set directly' do
      params = TestParams.new(name: 'John', age: 30, age_in_days: 100)
      expect(params.age_in_days).to eq(10950)
    end

    it 'can use real fields in calculations' do
      params = TestParams.new(name: 'Jane', age: 25)
      expect(params.age_in_days).to eq(9125)
      expect(params.full_description).to eq('Jane is 25 years old')
    end
  end

  describe 'ActiveModel compatibility' do
    let(:params) { TestParams.new(name: 'John', age: 30) }

    it 'includes model naming' do
      expect(params.class.model_name.name).to eq('TestParams')
    end

    it 'includes conversion methods' do
      expect(params).to respond_to(:to_model)
      expect(params).to respond_to(:to_key)
      expect(params).to respond_to(:to_param)
    end
  end
end

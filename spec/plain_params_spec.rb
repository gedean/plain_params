require 'rspec'
require_relative './fixtures/person_params'


RSpec.describe PlainParams do
  before(:all) do
    @test_plain_params = PersonParams.new name: 'Jonh'
  end

  # describe 'PlainParams'
  #   it 'raises an error for duplicated fields' do
  #     expect { @test_plain_params}.to raise_error(RuntimeError, "Duplicated field(s) 'real_field1' in @real_fields and @virtual_fields")
  #   end

    # it 'raises an error for duplicated fields' do
    #   expect { @test_plain_params}.to raise_error(RuntimeError, "Duplicated field(s) 'real_field1' in @real_fields and @virtual_fields")
    # end

    # it 'raises an error for invalid fields' do
    #   expect { @test_plain_params.non_existent_field = 'none' }.to raise_error(RuntimeError, "field 'non_existent_field' is not in @real_fields or @virtual_fields")
    # end
  end

  # describe 'Test params' do
  #   it 'raises an error for invalid fields' do
  #     expect { @test_plain_params.non_existent_field = 'none' }.to raise_error(RuntimeError, "field 'non_existent_field' is not in @real_fields or @virtual_fields")
  #   end
  # end

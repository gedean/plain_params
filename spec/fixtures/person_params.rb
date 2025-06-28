require_relative '../../lib/plain_params'

class PersonParams < PlainParams
  @real_fields = %i[name age]
  @virtual_fields = %i[age_group]

  def age_group
    return :child if age < 18
    return :adult if age < 65
    :senior
  end
end
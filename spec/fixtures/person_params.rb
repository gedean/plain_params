require_relative '../../lib/plain_params'

class PersonParams < PlainParams
  @real_fields = %i[name age]
  #@virtual_fields = %i[city]

  validates_presence_of :name, :age
end
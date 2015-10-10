require 'data_mapper'
require 'dm-validations'

class Peep

  include DataMapper::Resource

  property :id, Serial
  property :message, String, required: true

  belongs_to :user

end

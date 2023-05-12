require_relative 'base_model'

class Rider < Sequel::Model
  one_to_many :rides
  one_to_many :payment_methods
end
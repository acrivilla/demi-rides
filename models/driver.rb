require_relative 'base_model'

class Driver < Sequel::Model
  plugin :enum
  enum :status, [:free, :busy]

  one_to_many :rides
end
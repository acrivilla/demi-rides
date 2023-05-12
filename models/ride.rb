require_relative 'base_model'

class Ride < Sequel::Model
  plugin :enum
  enum :status, [:started, :finished, :charged]

  many_to_one :driver
  many_to_one :rider
end
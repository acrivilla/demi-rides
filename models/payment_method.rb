require_relative 'base_model'

class PaymentMethod < Sequel::Model
  plugin :enum
  enum :type, [:card, :nequi]

  one_to_one :rider
end
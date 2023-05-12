require './models/rider'
require './models/payment_method'
require './app/clients/payment_client'
require 'pry'

class RidersService
  def initialize(params)
    @params = params
  rescue => error
    error.message
  end

  def create_payment_method
    rider = Rider.find(@params['rider_id']).first
    type = @params['type'] == 'card' ? :card : :nequi
    token = @params['token']
    response = payment_service('payment_method', rider, token, type)

    if response.keys.include?('error')
      {message: response['error']}
    else
      external_id = response['data']['id']
      payment_method = PaymentMethod.create(rider_id: rider.id,
        external_id: response['data']['id'], token: token, type: type)

      {payment_method_id: payment_method.id, message: 'payment method created'}
    end

  rescue => error
    {message: error.message}
  end

  private

  def payment_service(operation, rider, token, type)
    client = PaymentClient.new(operation, {rider: rider, token: token, type: type})
    client.send_message
  end
end

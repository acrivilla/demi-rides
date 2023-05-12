require './models/rider'
require './models/driver'
require './models/ride'
require './models/payment_method'
require './app/clients/payment_client'
require './app/services/calculate_service'
require 'pry'

class RidesService
  def initialize(params)
    @params = params
  end

  def create_ride
    if free_driver
      ride = Ride.create(rider_id: @params['rider_id'], driver_id: free_driver.id,
        start_at: DateTime.now, initial_latitude: @params['initial_latitude'],
        initial_longitude: @params['initial_longitude'], final_latitude: @params['final_latitude'],
        final_longitude: @params['final_longitude'], status: :started)
      change_driver_status(free_driver, :busy)

      {ride_id: ride.id, message: "Driver found, Say hello!! to #{free_driver.name}"}
    else
      {message: 'Unavailable drivers'}
    end
  rescue => error
    {message: error.messages.join(',')}
  end

  def finish_ride
    ride = Ride.find(@params).first

    if ride
      ride.update(end_at: DateTime.now, status: :finished) unless ride.end_at
      change_driver_status(ride.driver, :free)
      transaction = create_transaction(ride, calculate_total_amount(ride))

      if transaction.keys.include?('error')
        {message: response['error']}
      else
        ride.update(status: :charged, transaction_id: transaction['data']['id'])
        {
          ride_id: ride.id, transaction_id: transaction['data']['id'],
          message: "transaction created in status #{transaction['data']['status']}"
        }
      end
    else
      {message: "Ride #{@params} not found"}
    end
  rescue => error
    {message: error.messages.join(',')}
  end

  private

  def free_driver
    @free_driver ||= Driver.where(status: 0).first
  end

  def change_driver_status(driver, status)
    driver.update(status: status)
  end

  def calculate_total_amount(ride)
    calculate_service = CalculateService.new(ride).total_amount

    calculate_service[:total_amount]
  end

  def create_transaction(ride, total_amount)
    if ride.rider.payment_methods.any?
      payment_client = PaymentClient.new('transactions', {ride: ride, total_amount: total_amount})
      payment_client.send_message
    else
      {message: 'There are not payment methods for client'}
    end
  end
end
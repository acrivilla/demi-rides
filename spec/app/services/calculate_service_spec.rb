require './models/ride'
require './app/services/calculate_service'
require 'time'

RSpec.describe CalculateService do
  let(:ride) do
    Ride.new(
      initial_latitude: 40.7128,
      initial_longitude: -74.0060,
      final_latitude: 34.0522,
      final_longitude: -118.2437,
      start_at: Time.parse('2023-05-10 08:00:00'),
      end_at: Time.parse('2023-05-10 09:30:00')
    )
  end

  describe '#total_amount' do
    subject { CalculateService.new(ride) }

    it 'returns the correct total amount for the ride' do
      expected_distance = 3936
      expected_time = 90
      expected_fee = 3500
      expected_total_amount = 395750000

      result = subject.total_amount

      expect(result[:distance]).to eq(expected_distance)
      expect(result[:time]).to eq(expected_time)
      expect(result[:fee]).to eq(expected_fee)
      expect(result[:total_amount]).to eq(expected_total_amount.to_i)
    end
  end
end
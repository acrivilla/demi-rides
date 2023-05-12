require './models/ride'
require 'time'
require 'time_difference'

class CalculateService
  def initialize(ride)
    @ride = ride
  end

  def total_amount
    distance = distance(@ride.initial_latitude, @ride.initial_longitude,
      @ride.final_latitude, @ride.final_longitude, 'K').round
    time = time(@ride.start_at, @ride.end_at)
    fee = 3500
    total_amount = (distance * 1000) + (time * 200) + fee
    total_amount = total_amount.to_s + '00'

    {distance: distance, time: time, fee: fee, total_amount: total_amount.to_i}
  end

  private

  ##method based on Spherical Law of Cosines
  ##https://www.geodatasource.com/resources/tutorials/how-to-calculate-the-distance-between-2-locations-using-ruby/
  def distance(lat1, lon1, lat2, lon2, unit)
    if (lat1 == lat2) && (lon1 == lon2)
      return 0
    else
      theta = lon1 - lon2
      dist = Math.sin(lat1 * Math::PI / 180) * Math.sin(lat2 * Math::PI / 180) + Math.cos(lat1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) * Math.cos(theta * Math::PI / 180)
      dist = Math.acos(dist)
      dist = dist * 180 / Math::PI
      miles = dist * 60 * 1.1515
      unit = unit.upcase

      if unit == 'K'
        return miles * 1.609344
      elsif unit == 'N'
        return miles * 0.8684
      else
        return miles
      end
    end
  end

  def time(start_at, end_at)
    TimeDifference.between(start_at, end_at).in_minutes.round
  end
end
require 'sinatra'
require './app/services/riders_service'
require './app/services/rides_service'
require 'pry'

def parse_request(request)
  if request
    request.body.rewind
    return JSON.parse(request.body.read)
  end
end

post '/payment_methods' do
  riders_service = RidersService.new(parse_request(request))
  return riders_service.create_payment_method.to_json
end

post '/rides' do
  rides_service = RidesService.new(parse_request(request))
  return rides_service.create_ride.to_json
end

patch '/rides/:ride_id/finish' do
  rides_service = RidesService.new(params[:ride_id].to_i)
  return rides_service.finish_ride.to_json
end
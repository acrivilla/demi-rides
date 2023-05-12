require 'sequel'

DB = Sequel.sqlite('./db/rides.db')

def create_riders
  DB[:riders].insert(name: "Pepito Perez", email: 'acrivilla@gmail.com')
end

def create_drivers
  20.times do |num|
    DB[:drivers].insert(name: "driver_#{num}")
  end
end

create_riders
puts 'riders created'
create_drivers
puts 'drivers created'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Airport.create(name: "San Francisco", code: "SFO")
Airport.create(name: "New York", code: "JFK")
Airport.create(name: "Raleigh - Durham", code: "RDU")
Airport.create(name: "Portland", code: "PDX")

Flight.create(duration: 5, departure_airport_id: 1, departure_time: DateTime.new(2021, 9, 6), price: 100, arrival_airport_id: 3)
Flight.create(duration: 7, departure_airport_id: 1, departure_time: DateTime.new(2021, 9, 8), price: 200, arrival_airport_id: 2)
Flight.create(duration: 2, departure_airport_id: 2, departure_time: DateTime.new(2021, 9, 7), price: 100, arrival_airport_id: 3)
Flight.create(duration: 6, departure_airport_id: 3, departure_time: DateTime.new(2021, 9, 7), price: 400, arrival_airport_id: 4)
Flight.create(duration: 1, departure_airport_id: 1, departure_time: DateTime.new(2021, 9, 6), price: 50, arrival_airport_id: 4)
Flight.create(duration: 5, departure_airport_id: 2, departure_time: DateTime.new(2021, 9, 8), price: 100, arrival_airport_id: 1)

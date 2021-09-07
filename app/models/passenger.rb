class Passenger < ApplicationRecord
  before_save { email.downcase! }
  belongs_to :booking
  has_many :flights, through: :bookings
end

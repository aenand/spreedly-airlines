class AddTrxIdToBookings < ActiveRecord::Migration[6.1]
  def change
    add_column :bookings, :trx_id, :string
  end
end

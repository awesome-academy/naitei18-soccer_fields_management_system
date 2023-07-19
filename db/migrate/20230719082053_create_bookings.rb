class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.string :name
      t.string :phone_number
      t.date :date_booking
      t.time :start_time
      t.time :end_time
      t.integer :total_cost
      t.integer :status, default: 0
      t.references :football_pitch, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

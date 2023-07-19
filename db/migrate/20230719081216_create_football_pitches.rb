class CreateFootballPitches < ActiveRecord::Migration[6.1]
  def change
    create_table :football_pitches do |t|
      t.string :name
      t.string :location
      t.integer :price_per_hour
      t.references :football_pitch_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end

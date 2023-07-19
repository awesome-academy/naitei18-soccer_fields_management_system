class CreateFootballPitchTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :football_pitch_types do |t|
      t.string :name
      t.integer :length
      t.integer :width

      t.timestamps
    end
  end
end

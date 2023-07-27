class CreateFollow < ActiveRecord::Migration[6.1]
  def change
    create_table :follows do |t|
      t.references :football_pitch, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

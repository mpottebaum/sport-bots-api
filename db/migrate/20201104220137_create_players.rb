class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.integer :bot_id
      t.integer :roster_id
      t.integer :type

      t.timestamps
    end
  end
end

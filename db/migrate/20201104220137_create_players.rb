class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.integer :bot_id
      t.integer :team_id
      t.string :designation

      t.timestamps
    end
  end
end

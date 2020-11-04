class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :type
      t.integer :speed
      t.integer :strength
      t.integer :agility

      t.timestamps
    end
  end
end

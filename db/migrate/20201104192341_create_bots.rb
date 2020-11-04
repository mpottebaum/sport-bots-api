class CreateBots < ActiveRecord::Migration[6.0]
  def change
    create_table :bots do |t|
      t.integer :team_id
      t.string :name
      t.integer :speed
      t.integer :strength
      t.integer :agility

      t.timestamps
    end
  end
end

class ChangeTeamIdToRosterIdOnPlayers < ActiveRecord::Migration[6.0]
  def change
    remove_column :players, :team_id, :integer
    add_column :players, :roster_id, :integer
  end
end

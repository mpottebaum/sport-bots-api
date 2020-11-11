class Roster < ApplicationRecord
    belongs_to :team
    has_many :players, dependent: :destroy

    accepts_nested_attributes_for :players

    validate :validate_roster_count, :validate_designation_counts, :validate_attribute_sums, on: [:create, :update]

    def starters
        players.filter {|player| player.designation == 'starter'}
    end

    def alternates
        players.filter {|player| player.designation == 'alternate'}
    end

    def num_starters
        starters.count
    end

    def num_alternates
        alternates.count
    end


    # created to replace Player records with Bot records in JSON responses
    def starters_json
        starters.map do |player|
            player.bot
        end
    end

    # created to replace Player records with Bot records in JSON responses
    def alternates_json
        alternates.map do |player|
            player.bot
        end
    end

    # created to add Player record IDs to params
    def update_players(roster_params)
        players.each.with_index do |player, i|
            roster_params[:players_attributes][i][:id] = player.id
        end
        update(roster_params)
    end

    private

    def validate_roster_count
        if players.length != 15
            errors.add(:team_id, "Roster must have 15 players")
        end
    end

    def validate_designation_counts
        if num_starters != 10
            errors.add(:team_id, "Roster must have 10 starters")
        end
        if num_alternates != 5
            errors.add(:team_id, "Roster must have 5 alternates")
        end
    end

    def validate_attribute_sums
        sum_lib = {}
        players.each do |player|
            if !player.bot
                errors.add(:team_id, "Roster contains one or more invalid bots")
                return nil
            end
            attributes_sum = player.bot.attributes_sum
            if sum_lib[attributes_sum]
                errors.add(:team_id, "Rosters cannot have two bots with the same attribute sum.")
                return nil
            end
            sum_lib[attributes_sum] = true
        end
    end
end
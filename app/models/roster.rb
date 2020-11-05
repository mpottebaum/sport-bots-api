class Roster < ApplicationRecord
    belongs_to :team
    has_many :players, dependent: :destroy

    accepts_nested_attributes_for :players

    validate :validate_roster_count, :validate_attribute_sums

    def num_starters
        players.filter {|player| player.designation == 'starter'}.count
    end

    def num_alternates
        players.filter {|player| player.designation == 'alternates'}.count
    end

    private

    def validate_roster_count
        if players.length != 15
            errors.add(:team_id, "Roster is invalid")
        end
    end

    def validate_attribute_sums
        sum_lib = {}
        players.each do |player|
            attributes_sum = player.bot.attributes_sum
            if sum_lib[attributes_sum]
                errors.add(:team_id, "Rosters cannot have two bots with the same attribute sum.")
                return nil
            end
            sum_lib[attributes_sum] = true
        end
    end
end
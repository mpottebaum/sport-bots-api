class Player < ApplicationRecord
    # join table for saved roster data
    belongs_to :roster
    belongs_to :bot

    validate :validate_bot, :validate_roster_length, :validate_roster_designation_counts

    private

    def validate_bot
        if !roster.team.bots.exists?(bot_id)
            errors.add(:bot_id, "Bot is not associated with this team")
        end
    end

    def validate_roster_length
        if roster.players.length > 15
            errors.add(:roster_id, "Roster has too many players")
        end
    end

    def validate_roster_designation_counts
        if designation == 'starter' && roster.num_starters > 10
            errors.add(:roster_id, "Roster has too many starters")
        elsif designation == 'alternate' && roster.num_alternates > 5
            errors.add(:roster_id, "Roster has too many alternates")
        end
    end
end

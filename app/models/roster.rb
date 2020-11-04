class Roster < ApplicationRecord
    belongs_to :team

    has_many :players
    has_many :bots, through: :players
end

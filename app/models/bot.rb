class Bot < ApplicationRecord
    belongs_to :team

    has_many :players
    has_many :rosters, through: :players
end

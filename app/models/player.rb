class Player < ApplicationRecord
    belongs_to :roster
    belongs_to :bot
end

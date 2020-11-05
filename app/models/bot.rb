class Bot < ApplicationRecord
    belongs_to :team

    has_one :player

    def self.generate_attributes
        attributes = [:speed, :strength, :agility].shuffle.reduce({ :available_points => 100 }) do |memo, key|
            max = memo[:available_points] < 50 ? memo[:available_points] : 50
            attribute_value = rand(1..max)
            memo[key] = attribute_value
            memo[:available_points] -= attribute_value
            memo
        end
        attributes.delete(:available_points)
        attributes
    end
end

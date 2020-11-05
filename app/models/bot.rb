class Bot < ApplicationRecord
    belongs_to :team

    has_one :player

    def self.generate_attributes
        # :available_points keeps track of attribute point sum
        initial_memo = { :available_points => 100 }
        # build attributes hash from shuffled array of attribute keys
        attributes = [:speed, :strength, :agility].shuffle.reduce(initial_memo) do |memo, key|
            # determine max value for random number range
            # based on :available_points
            max = memo[:available_points] < 50 ? memo[:available_points] : 50
            # generate random attribute value
            attribute_value = rand(1..max)
            # assign value to attribute key
            memo[key] = attribute_value
            # update :available_points count
            memo[:available_points] -= attribute_value
            # return updated memo hash
            memo
        end
        # delete :available_points key
        attributes.delete(:available_points)
        # return hash with attribute keys
        # hash is passed directly into Bot.create
        attributes
    end

    def attributes_sum
        speed + strength + agility
    end
end

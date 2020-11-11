class Team < ApplicationRecord
    has_secure_password
    validates :name, uniqueness: true
    validates :email, uniqueness: true

    has_many :bots, dependent: :destroy
    has_one :roster, dependent: :destroy

    # Manually runs TeamsSerializer
    # added to remove password_digest and date stamps from JSON responses
    def serialized
        ActiveModelSerializers::Adapter::Json.new(
                TeamsSerializer.new(self)
        ).serializable_hash
    end

    # generates 100 bots using seeded Name data
    # and randomized attributes
    def generate_bots
        Name.all.sample(100).each do |name_record|
            bot_data = Bot.generate_attributes.merge({
                name: name_record.name
            })
            bots.create(bot_data)
        end
    end

    def generate_roster
        # select 15 random bots
        bots_sample = bots.sample(15)
        # empty array to store valid players
        valid_roster = []
        # empty hash to store roster play attribute sums
        sum_lib = {}
        # added iteration count to optimize process time
        iteration_count = 0
        while valid_roster.length < 15 do
            # after 5 iterations, select 15 new random bots
            # reset iteration count
            if iteration_count > 5
                bots_sample = bots.sample(15)
                iteration_count = 0
            end
            # go through each selected bot
            # return new sum_lib with valid players' attribute sums
            # and array of valid players
            validate_result = bots_sample.reduce({ lib: sum_lib, bots: [] }) do |acc, bot|
                acc_copy = acc
                sum = bot.attributes_sum
                if acc[:lib][sum]
                    acc
                else
                    acc_copy[:lib][sum] = true
                    acc_copy[:bots].push(bot)
                    acc_copy
                end
            end

            # add newly validated bots to roster
            valid_roster = valid_roster + validate_result[:bots]
            # update sum_lib with new lib
            sum_lib = validate_result[:lib]
            # reduce sample size to number of spots left on roster
            sample_size = 15 - valid_roster.length
            # select new group of random bots
            # only selects number of bots needed to fill roster
            bots_sample = bots.sample(sample_size)
            # increment iteration count
            iteration_count += 1
        end

        # divide valid roster bots into starters and alts
        starters = valid_roster.slice(0, 10)
        alternates = valid_roster.slice(10, 16)
        # return roster hash
        {
            starters: starters,
            alternates: alternates
        }
    end
end
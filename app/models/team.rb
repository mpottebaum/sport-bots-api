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
        bots_sample = bots.sample(15)
        valid_roster = []
        sum_lib = {}
        iteration_count = 0
        while valid_roster.length < 15 do
            if iteration_count > 5
                bots_sample = bots.sample(15)
                iteration_count = 0
            end
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

            valid_roster = valid_roster + validate_result[:bots]
            sum_lib = validate_result[:lib]
            sample_size = 15 - valid_roster.length
            bots_sample = bots.sample(sample_size)
            iteration_count += 1
        end

        starters = valid_roster.slice(0, 10)
        alternates = valid_roster.slice(10, 16)
        {
            starters: starters,
            alternates: alternates
        }
    end
end
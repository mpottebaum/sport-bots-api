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
end
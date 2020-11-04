class Team < ApplicationRecord
    has_secure_password
    validates :name, uniqueness: true
    validates :email, uniqueness: true

    has_many :bots, dependent: :destroy
    has_many :rosters, dependent: :destroy

    # Manually runs TeamsSerializer
    # added to remove password_digest and date stamps from JSON responses
    def serialized
        ActiveModelSerializers::Adapter::Json.new(
                TeamsSerializer.new(self)
        ).serializable_hash
    end

    def generate_bots
        Name.all.sample(100).each do |name_record|
            bots.create({
                name: name_record.name,
                speed: rand(1..50),
                strength: rand(1..50),
                agility: rand(1..50),
            })
        end
    end
end

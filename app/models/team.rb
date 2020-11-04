class Team < ApplicationRecord
    has_secure_password
    validates :name, uniqueness: true
    validates :email, uniqueness: true

    # Manually runs TeamsSerializer
    # added to remove password_digest and date stamps from JSON responses
    def serialized
        ActiveModelSerializers::Adapter::Json.new(
                TeamsSerializer.new(self)
        ).serializable_hash
    end
end

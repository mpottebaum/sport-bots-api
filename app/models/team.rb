class Team < ApplicationRecord
    has_secure_password
    validates :name, uniqueness: true
    validates :email, uniqueness: true
end

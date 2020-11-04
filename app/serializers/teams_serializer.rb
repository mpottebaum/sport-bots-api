class TeamsSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :bots
end

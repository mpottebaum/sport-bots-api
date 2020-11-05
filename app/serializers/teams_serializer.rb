class TeamsSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :bots, :roster

  def roster
    object.roster
  end
end

class TeamsSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :saved_roster

  def saved_roster
    !!object.roster
  end

end

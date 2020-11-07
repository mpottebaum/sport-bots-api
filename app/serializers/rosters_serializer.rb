class RostersSerializer < ActiveModel::Serializer
  attributes :id, :players

  def players
    object.players
  end
end

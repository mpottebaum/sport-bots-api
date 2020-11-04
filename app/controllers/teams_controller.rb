class TeamsController < ApplicationController
    def create
        team = Team.create(team_params)
        
        if team.valid?
            token = encode_token(team_id: team.id)

            # Manually runs TeamsSerializer, removes password_digest from resp
            serialized_team = ActiveModelSerializers::Adapter::Json.new(
                TeamsSerializer.new(team)
            ).serializable_hash

            render json: { team: serialized_team, token: token }, status: 200
        else
            render json: { error: 'The name or email you provided are already taken' }, status: 406
        end
    end

    private

    def team_params
        params.require(:team).permit(:name, :email, :password)
    end
end
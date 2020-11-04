class TeamsController < ApplicationController
    def create
        team = Team.create(team_params)
        
        if team.valid?
            token = encode_token(team_id: team.id)
            render json: { team: team, token: token }, status: 200
        else
            render json: { error: 'The name or email you provided are already taken' }, status: 406
        end
    end

    private

    def team_params
        params.require(:team).permit(:name, :email)
    end
end
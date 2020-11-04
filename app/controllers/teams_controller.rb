class TeamsController < ApplicationController
    skip_before_action :authorized, only: [:create]

    def create
        team = Team.create(team_params)
        
        if team.valid?
            # creates JWT
            token = encode_token(team_id: team.id)
            # creates 100 bots
            team.generate_bots
            
            render json: team.serialized.merge(token: token), status: 200
        else
            render json: { error: 'The name or email you provided are already taken' }, status: 406
        end
    end

    private

    def team_params
        params.require(:team).permit(:name, :email, :password)
    end
end
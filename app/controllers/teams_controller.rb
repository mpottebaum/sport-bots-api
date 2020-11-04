class TeamsController < ApplicationController
    def create
        team = Team.create(team_params)
        
        if team.valid?
            render json: { team: team }, status: 200
        else
            render json: { error: 'The name or email you provided are already taken' }, status: 406
        end
    end

    private

    def team_params
        params.require(:team).permit(:name, :email)
    end
end
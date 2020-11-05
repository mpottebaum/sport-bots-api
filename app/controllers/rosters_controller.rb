class RostersController < ApplicationController
    def create
        team = Team.find(params[:id])
        team.players.create(roster_params[:bots])

        render json: { roster: team.roster }, status: 200
    end

    private

    def roster_params
        params.require(:roster).permit(:bots => [:bot_id, :designation])
    end
end
class RostersController < ApplicationController
    def create
        team = Team.find(params[:id])

        roster = team.create_roster(roster_params)
        if roster.valid?
            render json: { roster: roster }, status: 200
        else
            render json: { errors: roster.errors.messages.values }, status: 406
        end
    end

    private

    def roster_params
        params.require(:roster).permit(:players_attributes => [:bot_id, :designation])
    end
end
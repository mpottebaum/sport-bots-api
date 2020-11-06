class BotsController < ApplicationController
    def index
        team = Team.find(params[:id])

        if team
            render json: { bots: team.bots }, status: 200
        else
            render json: {
                error: {
                    messages: ['No team exists with the provided ID']
                }
            }, status: 402
        end
    end
end
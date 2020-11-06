class RostersController < ApplicationController
    def create
        team = Team.find(params[:id])

        roster = team.create_roster(roster_params)
        if roster.valid?
            render json: { roster: roster, bot_ids: roster.players }, status: 200
        else
            render json: { errors: roster.errors.messages.values }, status: 406
        end
    end

    def show
        team = Team.find(params[:id])
        roster = team.roster
        if roster
            render json: { roster: roster, players: roster.players }, status: 200
        else
            render json: { errors: ['Your team has not created a roster']}, status: 401
        end
    end

    def update
        team = Team.find(params[:id])
        roster = team.roster

        if roster
            update_is_valid = roster.update_players(roster_params)
            if update_is_valid
                render json: { roster: roster, players: team.roster.players}, status: 200
            else
                render json: { errors: ['Roster update is invalid']}, status: 406
            end
        else
            render json: { errors: ['You have not created a roster']}, status: 401
        end
    end

    def destroy
        team = Team.find(params[:id])
        roster = team.roster

        if roster
            roster.destroy
            render json: { message: 'success' }, status: 200
        else
            render json: { errors: 'You have not created a roster'}, status: 406
        end
    end

    private

    def roster_params
        params.require(:roster).permit(:players_attributes => [:bot_id, :designation])
    end
end

# lib = {}
# roster_params = {
#     players_attributes: []
# }
# team.bots.each do |bot|
#     points = bot.attributes_sum
#     if lib[points]
#     elsif roster_params[:players_attributes].length >= 15
#     else
#         lib[points] = true
#         designation = roster_params[:players_attributes].length < 10 ? 'starter' : 'alternate'
#         roster_params[:players_attributes].push({
#             bot_id: bot.id,
#             designation: designation
#         })
#     end
# end
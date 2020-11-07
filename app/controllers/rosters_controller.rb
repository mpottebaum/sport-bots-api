class RostersController < ApplicationController

    def random
        team = Team.find(params[:id])
        roster = team.generate_roster
        render json: { roster: roster }, status: 200
    end

    def create
        team = Team.find(params[:id])

        roster = team.create_roster(roster_params)
        if roster.valid?
            render json: { roster: {
                id: roster.id,
                starters: roster.starters_json,
                alternates: roster.alternates_json
            } }, status: 200
        else
            render json: { errors: roster.errors.messages.values }, status: 406
        end
    end

    def show
        team = Team.find(params[:id])
        roster = team.roster
        if roster
            render json: { roster: {
                id: roster.id,
                starters: roster.starters_json,
                alternates: roster.alternates_json
            }}, status: 200
        else
            render json: { roster: {} }, status: 200
        end
    end

    def update
        team = Team.find(params[:id])
        roster = team.roster

        if roster
            update_is_valid = roster.update_players(roster_params)
            if update_is_valid
                render json: { roster: {
                    id: roster.id,
                    starters: roster.starters_json,
                    alternates: roster.alternates_json
                }}, status: 200
            else
                render json: {
                    error: {
                        messages: ['Roster update is invalid']
                    }
                }, status: 406
            end
        else
            render json: {
                error: {
                    messages: ['You have not created a roster']
                }
            }, status: 401
        end
    end

    def destroy
        team = Team.find(params[:id])
        roster = team.roster

        if roster
            roster.destroy
            render json: { message: 'success' }, status: 200
        else
            render json: {
                error: {
                    messages: ['You have not created a roster']
                }
            }, status: 406
        end
    end

    private

    def roster_params
        params.require(:roster).permit(:players_attributes => [:bot_id, :designation])
    end
end
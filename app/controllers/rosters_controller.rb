class RostersController < ApplicationController

    def random
        team = Team.find(params[:id])
        if team
            roster = team.generate_roster
            render json: { roster: roster }, status: 200
        else
            render json: {
                error: { messages: ['No team exists with the provided ID.'] }
            }, status: 404
        end
    end

    def create
        team = Team.find(params[:id])

        if team
            roster = team.create_roster(roster_params)

            # check if supplied roster is valid
            if roster.valid?
                # if valid return roster with updated team record
                render json: team.serialized.merge({
                        roster: {
                                id: roster.id,
                                starters: roster.starters_json,
                                alternates: roster.alternates_json
                            }
                }), status: 200
            else
                # if roster is invalid, return validation errors
                render json: {
                    error: { messages: roster.errors.messages.values }
                }, status: 406
            end
        else
            render json: {
                error: { messages: ['No team exists with the provided ID.'] }
            }, status: 404
        end
    end

    def show
        team = Team.find(params[:id])
        if team
            roster = team.roster
            if roster
                # if team has saved roster, return it
                render json: { roster: {
                    id: roster.id,
                    starters: roster.starters_json,
                    alternates: roster.alternates_json
                }}, status: 200
            else
                # if team does not have saved roster, return empty hash
                render json: { roster: {} }, status: 200
            end
        else
            render json: {
                error: { messages: ['No team exists with the provided ID.'] }
            }, status: 404
        end
    end

    def update
        team = Team.find(params[:id])
        if team
            roster = team.roster

            if roster
                update_is_valid = roster.update_players(roster_params)
                if update_is_valid
                    # roster exists and update is valid
                    # return updated roster and updated team
                    render json: team.serialized.merge({
                        roster: {
                                id: roster.id,
                                starters: roster.starters_json,
                                alternates: roster.alternates_json
                            }
                }), status: 200
                else
                    # roster exists but update is invalid
                    render json: {
                        error: {
                            messages: ['Roster update is invalid']
                        }
                    }, status: 406
                end
            else
                # no roster exists
                render json: {
                    error: {
                        messages: ['You have not created a roster']
                    }
                }, status: 401
            end
        else
            # no team exists
            render json: {
                error: { messages: ['No team exists with the provided ID.'] }
            }, status: 404
        end
    end

    def destroy
        team = Team.find(params[:id])

        if team
            roster = team.roster

            if roster
                # team has roster
                roster.destroy
                team.save
                render json: { team: {
                    id: team.id,
                    name: team.name,
                    email: team.email,
                    saved_roster: false
                }}, status: 200
            else
                # team does not have saved roster
                render json: {
                    error: {
                        message: ['You have not created a roster']
                    }
                }, status: 406
            end
        else
            # no team exists
            render json: {
                error: { messages: ['No team exists with the provided ID.'] }
            }, status: 404
        end
    end

    private

    def roster_params
        params.require(:roster).permit(:players_attributes => [:bot_id, :designation])
    end
end
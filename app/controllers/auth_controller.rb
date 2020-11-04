class AuthController < ApplicationController
    skip_before_action :authorized

    def create
        team = Team.find_by(name: auth_params[:name])
        if team && team.authenticate(auth_params[:password])
            token = encode_token({team_id: team.id})
            render json: team.serialized.merge(token: token) , status: 200
        else
            render json: {error: 'The name or password you provided is incorrect'}, status: 401
        end
    end

    def show
        team = current_team
        if team
            token = encode_token({team_id: team.id})
            render json: team.serialized, status: 200
        else
            render json: {error: 'The token you provided is invalid'}, status: 401
        end
    end

    private

    def auth_params
        params.require(:auth).permit(:name, :password)
    end
end
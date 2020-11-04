class ApplicationController < ActionController::API

    def encode_token(team)
        JWT.encode(team, 's3cr3t', 'HS256')
    end
end

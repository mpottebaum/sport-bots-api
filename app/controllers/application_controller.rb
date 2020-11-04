class ApplicationController < ActionController::API
    before_action :authorized

    def encode_token(team)
        JWT.encode(team, 's3cr3t', 'HS256')
    end

    def auth_header
        request.headers['Authorization']
      end
     
      def decoded_token
        if auth_header
          token = auth_header.split(' ')[1]
          begin
            JWT.decode(token, 's3cr3t', true, algorithm: 'HS256')
          rescue JWT::DecodeError
            nil
          end
        end
      end
     
      def current_team
        if decoded_token
          team_id = decoded_token[0]['team_id']
          @team = Team.find_by(id: team_id)
        end
      end
     
      def logged_in?
        !!current_team
      end
     
      def authorized
        render json: { error: 'Please log in' }, status: :unauthorized unless logged_in?
      end  
end

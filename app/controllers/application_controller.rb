class ApplicationController < ActionController::API
    before_action :authenticate_request
    
    attr_reader :current_user
    
    private
    def authenticate_request
      header = request.headers['Authorization']
      token = header.split(' ').last if header
  
      begin
        decoded = JsonWebToken.decode(token)
        @current_user = User.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        render json: { errors: 'Unauthorized' }, status: :unauthorized
      end
    end
    
end

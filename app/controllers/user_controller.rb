class UserController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_user

    def show
        return render json: { error: "Unauthorized" }, status: :unauthorized unless session.include? :user_id
        
        user = User.find(session[:user_id])
        render json: user, status: :created
    end

    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end

    def unprocessable_user(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
    
end

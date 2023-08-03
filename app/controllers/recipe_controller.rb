class RecipeController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_recipe

    def index
        if session[:user_id]
            render json: Recipe.all, status: :created
        else
            render json: { errors: ["Not Logged In"] }, status: :unauthorized
        end
    end

    def create
        if session[:user_id]
            recipe = Recipe.create!(
            user_id: session[:user_id], 
            title: params[:title], 
            instructions: params[:instructions], 
            minutes_to_complete: params[:minutes_to_complete]
            )
            render json: recipe, status: :created
        else
            render json: { errors: ["Not Logged In"] }, status: :unauthorized
        end
    end


    private

    def unprocessable_recipe(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

end

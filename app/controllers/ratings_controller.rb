class RatingsController < ApplicationController

	def index
		@ratings = Rating.all
	end

	def new
		@rating = Rating.new
	end

	def create
		@rating = Rating.new(rating_params)

		if @rating.save
			redirect_to new_rating_path, notice: 'Your rating was submitted successfully!'
		else

		end
	end

	private

	def rating_params
		params.require(:rating).permit(:username, :product, :score)
	end
end

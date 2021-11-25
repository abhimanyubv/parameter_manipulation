class RatingsController < ApplicationController
	SIGNATURE_VERIFY_KEY = "\x94q4:\xED\x13\v\xFEOx^,z\xDAy\xE5\xFB\x1Eb\x1F2\x92p\x1A\xE8;\xAF\x9A\xE5\xBD\x10X"

	def index
		@ratings = Rating.all
	end

	def new
		@rating = Rating.new
	end

	def safe_new
		@rating = Rating.new
	end

	def create
		@rating = Rating.new(rating_params)

		if @rating.save
			redirect_to new_rating_path, notice: 'Your rating was submitted successfully!'
		else
			redirect_to new_rating_path, notice: 'Failed to save your rating.'
		end
	end

	def safe_create
		dumped_signature = "\"" + signature_param + "\""
		signature = Base64.decode64(dumped_signature.undump)

		verification_key = Ed25519::VerifyKey.new(SIGNATURE_VERIFY_KEY)

		begin
			verification_key.verify(signature, rating_params.values.join(';'))
		rescue ArgumentError => error
			Rails.logger.error(error)
			redirect_to ratings_safe_new_path, notice: 'Invalid signature!'
			return
		end

		rating = Rating.new(rating_params)

		if rating.save
			redirect_to ratings_safe_new_path, notice: 'Your rating was submitted successfully!'
		else
			redirect_to ratings_safe_create_path, notice: 'Failed to save your rating.'
		end
	rescue Ed25519::VerifyError => error
		Rails.logger.error(error)
		redirect_to ratings_safe_new_path, notice: 'Invalid signature!'
	end

	private

	def rating_params
		params.require(:rating).permit(:username, :product, :score)
	end

	def signature_param
		params.require(:rating)[:signature]
	end
end

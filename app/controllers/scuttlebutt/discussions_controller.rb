module Scuttlebutt
	class DiscussionsController < ApplicationController

		def index
			@discussions = Discussion.published
		end

		def show
			@discussion = Discussion.published.friendly.find( params[:id] )

			if current_user.read_attribute_before_type_cast( :role ).to_i < @discussion.read_attribute_before_type_cast( :availability ).to_i
				puts "You don't have permission ot access this discussion"
				redirect_back( fallback_location: '/' )
				return false
			end

			@topics = @discussion.topics.active.order( created_at: :desc ).page( params[:page] )

		end

	end
end

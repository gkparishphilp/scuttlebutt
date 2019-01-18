module Scuttlebutt
	class DiscussionsController < ApplicationController

		def index
			@discussions = Discussion.published.order( created_at: :asc )

			set_page_meta title: "Discussions"

			log_event( { name: 'pageview', content: "viewed the discussions index page." } )
		end

		def show
			@discussion = Discussion.published.friendly.find( params[:id] )

			if not( @discussion.anyone? ) && current_user.read_attribute_before_type_cast( :role ).to_i < @discussion.read_attribute_before_type_cast( :availability ).to_i
				puts "You don't have permission ot access this discussion"
				redirect_back( fallback_location: '/' )
				return false
			end

			@topics = @discussion.topics.active.order( created_at: :desc ).page( params[:page] )


			set_page_meta title: @discussion.title

			log_event( { name: 'pageview', content: "viewed the discussions page #{@discussion}." } )

		end

	end
end

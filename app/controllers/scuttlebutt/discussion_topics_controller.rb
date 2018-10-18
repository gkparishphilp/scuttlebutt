
module Scuttlebutt
	class DiscussionTopicsController < ApplicationController

		before_action :authenticate_user!, except: :show

		def create
			@discussion = Discussion.published.friendly.find( params[:discussion_id] )

			if current_user.read_attribute_before_type_cast( :role ).to_i < @discussion.read_attribute_before_type_cast( :availability ).to_i
				puts "You don't have permission ot access this discussion"
				redirect_back( fallback_location: '/' )
				return false
			end

			@topic = DiscussionTopic.new( user: current_user, parent_obj_id: @discussion.id, parent_obj_type: @discussion.class.name, subject: params[:subject], content: params[:content] )
			@topic.sanitized_content = ActionView::Base.full_sanitizer.sanitize( @topic.content ) if @topic.content

			if @topic.save
				set_flash "Topic Posted"
			else
				set_flash "Couldn't create Topic", :danger, @topic
			end
			redirect_back( fallback_location: '/' )
		end

		def show
			@topic = DiscussionTopic.friendly.find( params[:id] )
			@discussion = @topic.discussion

			if current_user.read_attribute_before_type_cast( :role ).to_i < @discussion.read_attribute_before_type_cast( :availability ).to_i
				puts "You don't have permission ot access this discussion"
				redirect_to :back
				return false
			end

			@posts = @topic.posts.active.order( created_at: :desc ).page( params[:page] )
		end

	end

end

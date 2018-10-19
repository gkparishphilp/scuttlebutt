
module Scuttlebutt
	class DiscussionPostsController < ApplicationController

		before_action :authenticate_user!

		def create
			@topic = DiscussionTopic.active.friendly.find( params[:topic_id] )
			@post = DiscussionPost.new( user: current_user, parent_obj_id: @topic.id, parent_obj_type: @topic.class.name, content: params[:content] )
			@post.sanitized_content = ActionController::Base.helpers.sanitize( @post.content, tags: Scuttlebutt.post_allowed_tags, attributes: Scuttlebutt.post_allowed_attributes ) if @post.content

			if @post.save
				set_flash "Posted"
			else
				set_flash "Couldn't create Post", :danger, @post
			end
			redirect_back( fallback_location: '/' )
		end

		def edit

		end

		def update

		end

	end
end

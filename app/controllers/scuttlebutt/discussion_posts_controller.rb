
module Scuttlebutt
	class DiscussionPostsController < ApplicationController

		before_action :authenticate_user!

		def create
			@topic = DiscussionTopic.active.friendly.find( params[:topic_id] )
			@post = DiscussionPost.new( user: current_user, parent_obj_id: @topic.id, parent_obj_type: @topic.class.name, content: params[:content] )
			@post.sanitized_content = ActionController::Base.helpers.sanitize( @post.content, tags: Scuttlebutt.post_allowed_tags, attributes: Scuttlebutt.post_allowed_attributes ) if @post.content

			if @post.save
				set_flash "Posted"

				log_event( name: 'add_post', cateogry: 'social', on: @post.parent_obj, content: "posted to #{@post.parent_obj}" )

				if params[:optin] == '1' && not( ( subscription = Scuttlebutt::Subscription.find_or_initialize_by( user: @post.user, parent_obj: @post.root_parent_obj ) ).persisted? )
					log_event( name: 'follow', cateogry: 'social', on: @post.root_parent_obj, content: "started following #{@post.root_parent_obj}" ) if subscription.save
				end

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

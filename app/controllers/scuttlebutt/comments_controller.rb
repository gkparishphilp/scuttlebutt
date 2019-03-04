module Scuttlebutt
	class CommentsController < ApplicationController

		before_action 	:authenticate_user!, only: [:create,:update,:edit,:destroy]

		def create
			@comment = Comment.new( user: current_user )
			@comment.attributes = comment_params
			@comment.sanitized_content = ActionController::Base.helpers.sanitize( @comment.content, tags: Scuttlebutt.post_allowed_tags, attributes: Scuttlebutt.post_allowed_attributes ) if @comment.content
			
			respond_to do |format|
				if @comment.save

					log_event( name: 'comment', cateogry: 'social', on: @comment.parent_obj, content: "commented on #{@comment.parent_obj}" )

					if params[:optin] == '1' && not( ( subscription = Scuttlebutt::Subscription.find_or_initialize_by( user: @comment.user, parent_obj: @comment.root_parent_obj ) ).persisted? )
						log_event( name: 'follow', cateogry: 'social', on: @comment.root_parent_obj, content: "started following #{@comment.root_parent_obj}" ) if subscription.save
					end

					format.html {
						set_flash 'Thank you for your comment'
						back_path = @comment.parent_obj.try( :url )
						if back_path.present?
							back_path = back_path + "#comments"
							redirect_to back_path
						else
							redirect_back( fallback_location: '/' )
						end
					}
					format.js {}
				else
					format.html {
						set_flash 'Error, comment could not be saved.'
						redirect_back( fallback_location: '/' )
					}
					format.js {}
				end
			end
		end

		def index

			@parent_obj = params[:parent_obj_type].constantize.find(params[:parent_obj_id])

			@target = params[:target] #todo filter bad characters

			if params[:format].to_s == 'js'

				render 'swell_social/comments/index.js', layout: false

			else

				if params[:layout] == '0'
					render 'swell_social/comments/index', layout: false

				else
					render 'swell_social/comments/index'
				end

			end

		end

		def new
			@comment = Comment.new( user: current_user )
		end

		def widget
			@comment_widgets = []
			if params[:comment_widgets]
				params[:comment_widgets].each do |index,comment_widget|
					parent_obj = comment_widget[:parent_obj_type].constantize.find(comment_widget[:parent_obj_id])
					@comment_widgets << {
						parent_obj: parent_obj,
						selector: comment_widget[:selector],
						args: (comment_widget.permit(:args) || {}).to_h.symbolize_keys,
					}
				end
			else
				parent_obj = params[:parent_obj_type].constantize.find(params[:parent_obj_id])
				@comment_widgets << {
					parent_obj: parent_obj,
					selector: params[:selector],
					args: (params.permit(:args) || {}).to_h.symbolize_keys,
				}
			end
		end

		private

			def comment_params
				params.require( :comment ).permit( :title, :subject, :reply_to_id, :content, :status, :parent_obj_type, :parent_obj_id )
			end


	end
end

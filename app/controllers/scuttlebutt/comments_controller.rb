module Scuttlebutt
	class CommentsController < PostsController

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
			@post = Comment.new( user: current_user )
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

	end
end

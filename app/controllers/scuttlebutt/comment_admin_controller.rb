module Scuttlebutt
	class CommentAdminController < ApplicationAdminController

		before_action :get_comment, except: [ :index ]

		def index
			sort_by = params[:sort_by] || 'created_at'
			sort_dir = params[:sort_dir] || 'desc'

			@comments = Comment.order( "#{sort_by} #{sort_dir}" )

			if params[:status].present? && params[:status] != 'all'
				@comments = eval "@comments.#{params[:status]}"
			end

			@comments = @comments.page( params[:page] )
		end

		def edit
			
		end

		def update
			@comment.attributes = comment_params

			authorize( @comment )

			if @comment.save
				set_flash 'Comment Updated '
				redirect_to edit_comment_admin_path( id: @comment.id )
			else
				set_flash 'comment could not be Updated', :error, @comment
				render :edit
			end
		end

		private
			def comment_params
				params.require( :comment ).permit( :status )
			end

			def get_comment
				@comment = Comment.find( params[:id] )
			end



	end
end
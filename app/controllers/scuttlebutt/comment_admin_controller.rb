module Scuttlebutt
	class CommentAdminController < ApplicationAdminController

		def index
			sort_by = params[:sort_by] || 'created_at'
			sort_dir = params[:sort_dir] || 'desc'

			@comments = Comment.order( "#{sort_by} #{sort_dir}" )

			if params[:status].present? && params[:status] != 'all'
				@comments = eval "@comments.#{params[:status]}"
			end

			@comments = @comments.page( params[:page] )
		end

	end
end
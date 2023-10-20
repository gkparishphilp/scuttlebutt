module Scuttlebutt
	class PostAdminController < ApplicationAdminController
		before_action :get_post, except: [ :create, :empty_trash, :index ]

		def destroy
			authorize( @post )
			@post.trash!
			set_flash 'Post Trashed'
			redirect_back( fallback_location: '/admin' )
		end


		def edit
			authorize( @post )
		end


		def index
			authorize( Post )
			sort_by = params[:sort_by] || 'created_at'
			sort_dir = params[:sort_dir] || 'desc'

			@type_filter = ( params[:type] || 'all' )

			@posts = Post.joins(:user).order( Arel.sql("#{sort_by} #{sort_dir}") )
			@posts = @posts.where( status: params[:status] ) if params[:status].present? && params[:status] != 'all'
			@posts = @posts.where( user_id: params[:user_id] ) if params[:user_id]
			@posts = @posts.where( type: @type_filter ) unless @type_filter == 'all'
			@posts = @posts.term_search( params[:term] ).or( @posts.merge(User.term_search( params[:term] )) ) if params[:term].present?


			@posts = @posts.page( params[:page] )
		end


		def update

			@post.slug = nil if params[:post][:slug_pref].present?
			@post.attributes = post_params
			@post.sanitized_content = ActionController::Base.helpers.sanitize( @post.content, tags: Scuttlebutt.post_allowed_tags, attributes: Scuttlebutt.post_allowed_attributes ) if @post.content


			authorize( @post )

			if @post.save
				set_flash 'Post Updated'
				redirect_to edit_post_admin_path( id: @post.id )
			else
				set_flash 'Post could not be Updated', :error, @post
				render :edit
			end

		end


		private
			def post_params
				params.require( :post ).permit( :user_id, :parent_obj_type, :parent_obj_id, :reply_to_id, :type, :slug, :subject, :content, :sanitized_content, :rating, :status, :availability, :tags_csv, :mentions_csv )
			end

			def get_post
				@post = Post.friendly.find( params[:id] )
			end


	end
end

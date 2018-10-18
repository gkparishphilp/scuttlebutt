module Scuttlebutt
	class PostsController < ApplicationController

		before_action 	:authenticate_user!, only: [:create,:update,:edit,:destroy]

		def create

			@post = Post.new( type: params[:post][:type], user: current_user )
			@post.attributes = post_params
			@post.sanitized_content = ActionView::Base.full_sanitizer.sanitize( @post.content ) if @post.content

			respond_to do |format|
				if @post.save
					format.html {
						set_flash 'Success'
						redirect_back( fallback_location: '/' )
					}
					format.js {}
				else
					format.html {
						set_flash 'Error, post could not be saved.'
						redirect_back( fallback_location: '/' )
					}
					format.js {}
				end
			end

		end

		def destroy
			@post = Post.find( params[:id] )
			raise Exception.new( "Permission Denied" ) unless @post.user == current_user
			@post.update( status: 'trash' )

			respond_to do |format|
				format.html {
					set_flash 'Success'
					redirect_back( fallback_location: '/' )
				}
				format.js {}
			end
		end

		def edit
			@post = Post.where( user: current_user ).find( params[:id] )
			raise Exception.new( "Permission Denied" ) unless @post.user == current_user
		end

		def report
			@post = Post.find( params[:id] )

			log_event( { name: 'report', category: 'social', on: @post, content: "reported the post #{@post} (#{@post.id}) for moderation." } )

			respond_to do |format|
				format.html {
					set_flash 'Success'
					redirect_back( fallback_location: '/' )
				}
				format.js {}
			end
		end

		def show
			@post = Post.find( params[:id] )
		end

		def update
			@post = Post.where( user: current_user ).find( params[:id] )
			raise Exception.new( "Permission Denied" ) unless @post.user == current_user

			@post.attributes = post_params
			@post.sanitized_content = ActionView::Base.full_sanitizer.sanitize( @post.content ) if @post.content

			respond_to do |format|
				if @post.save
					format.html {
						set_flash 'Success'
						redirect_to( params[:back] || '/' )
					}
					format.js {}
				else
					format.html {
						set_flash 'Unable to perform update'
						redirect_to( params[:back] || '/' )}
					format.js {}
				end
			end

		end


		private

			def post_params
				params.require( :post ).permit( :title, :subject, :reply_to_id, :content, :status, :parent_obj_type, :parent_obj_id )
			end

	end
end

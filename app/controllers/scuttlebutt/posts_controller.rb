module Scuttlebutt
	class PostsController < ApplicationController

		before_action 	:authenticate_user!, only: [:create,:update,:edit,:destroy]

		def create

			@post = Post.new( type: params[:post][:type], user: current_user )
			@post.attributes = post_params
			@post.sanitized_content = ActionController::Base.helpers.sanitize( @post.content, tags: Scuttlebutt.post_allowed_tags, attributes: Scuttlebutt.post_allowed_attributes ) if @post.content

			respond_to do |format|
				if @post.save

					event_name = 'add_post'
					event_name = 'comment' if @post.is_a? Scuttlebutt::Comment
					log_event( name: event_name, cateogry: 'social', on: @post.parent_obj, content: "posted to #{@post.parent_obj}" )

					if params[:optin] == '1' && not( ( subscription = Scuttlebutt::Subscription.find_or_initialize_by( user: @post.user, parent_obj: @post.root_parent_obj ) ).persisted? )
						log_event( name: 'follow', cateogry: 'social', on: @post.root_parent_obj, content: "started following #{@post.root_parent_obj}" ) if subscription.save
					end

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
			@post.sanitized_content = ActionController::Base.helpers.sanitize( @post.content, tags: Scuttlebutt.post_allowed_tags, attributes: Scuttlebutt.post_allowed_attributes ) if @post.content

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

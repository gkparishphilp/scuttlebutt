
module Scuttlebutt
	class VotesController < ApplicationController
		before_action :authenticate_user!


		def index
			create
		end

		def create
			@vote = Vote.where( user_id: current_user.id, parent_obj_type: params[:parent_obj_type], parent_obj_id: params[:parent_obj_id], vote_type: params[:vote_type], context: params[:context] ).first_or_initialize
			@vote.val = params[:val].try( :to_i ) || params[:up].try( :to_i ) || 1

			if @vote.save
				@vote.update_parent_caches

				log_event( name: 'vote', cateogry: 'social', on: @vote.parent_obj, content: "voted #{@vote.val} #{@vote.parent_obj}" )

				if params[:optin] == '1' && @vote.up?
					parent_obj = @vote.parent_obj
					parent_obj = parent_obj.root_parent_obj if parent_obj.respond_to? :root_parent_obj
					unless ( subscription = Scuttlebutt::Subscription.find_or_initialize_by( user: @vote.user, parent_obj: parent_obj ) ).persisted?
						log_event( name: 'follow', cateogry: 'social', on: parent_obj, content: "started following #{parent_obj}" ) if subscription.save
					end
				end

				respond_to do |format|
					format.html { redirect_back( fallback_location: '/' ) }
					format.js {}
				end
			else
				@error = 'Vote could not be saved'
				set_flash @error, :error, @vote

				respond_to do |format|
					format.html { redirect_back( fallback_location: '/' ) }
					format.js {}
				end
			end
		end


		def destroy
			@vote = Vote.where( user: current_user ).find_by( parent_obj_id: params[:id], parent_obj_type: params[:parent_obj_type] ) if params[:parent_obj_type].present? && params[:parent_obj_id].nil?
			@vote ||= Vote.where( user: current_user ).find_by( context: params[:id] )
			@vote ||= Vote.where( user: current_user ).find( params[:id] )

			@vote.destroy
			@vote.update_parent_caches

			respond_to do |format|
				format.html { redirect_back( fallback_location: '/' ) }
				format.js {}
			end
		end

		def update
			# this action flips the vote!, unless updating what the vote is for.
			@vote = Vote.where( user: current_user ).find_by( parent_obj_id: params[:parent_obj_id], parent_obj_type: params[:parent_obj_type] ) if params[:parent_obj_type].present? && params[:parent_obj_id].nil?
			@vote ||= Vote.where( user: current_user ).find_by( context: params[:id] )
			@vote ||= Vote.where( user: current_user ).find( params[:id] )

			if params[:parent_obj_type]
				@old_parent_obj = @vote.parent_obj
				@vote.parent_obj_type = params[:parent_obj_type]
				@vote.parent_obj_id = params[:parent_obj_id]
			elsif @vote.up?
				dir = 'down'
				@vote.val = dir
			else
				dir = 'up'
				@vote.val = dir
			end

			puts "@vote #{@vote.to_json}"

			if @vote.save
				log_event( name: 'changed_vote', cateogry: 'social', on: @vote.parent_obj, content: "voted #{@vote.val} #{@vote.parent_obj}" )

				@vote.update_parent_caches
			end

			respond_to do |format|
				format.html { redirect_back( fallback_location:'/' ) }
				format.js {}
			end
		end

		def widget
			@vote_widgets = []
			if params[:vote_widgets]
				params[:vote_widgets].each do |index,vote_widget|
					parent_obj = vote_widget[:parent_obj_type].constantize.find(vote_widget[:parent_obj_id])
					@vote_widgets << {
						parent_obj: parent_obj,
						selector: vote_widget[:selector],
						args: (vote_widget.permit(:args) || {}).to_h.symbolize_keys,
					}
				end
			else
				parent_obj = params[:parent_obj_type].constantize.find(params[:parent_obj_id])
				@vote_widgets << {
					parent_obj: parent_obj,
					selector: params[:selector],
					args: (params.permit(:args) || {}).to_h.symbolize_keys,
				}
			end
		end


	end
end

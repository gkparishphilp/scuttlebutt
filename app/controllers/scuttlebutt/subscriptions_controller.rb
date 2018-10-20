
module Scuttlebutt
	class SubscriptionsController < ApplicationController

		before_action :authenticate_user!

		def create
			subscription_params = params.require(:subscription).permit(:parent_obj_type, :parent_obj_id)
			@sub = Subscription.where( subscription_params.merge( user_id: current_user.id ) ).first_or_initialize

			respond_to do |format|

				if @sub.persisted?
				  if @sub.active!
						format.html {
							set_flash "Subscribed", :success
							redirect_back( fallback_location: '/' )
						}
						format.js { render 'create' }
					else
						format.html {
							set_flash "Unable to subscribe", :error
							redirect_back( fallback_location: '/' )
						}
						format.js { render 'create' }
				  end
				else
				  if @sub.active!
						log_event( name: 'follow', cateogry: 'social', on: @sub.parent_obj, content: "started following #{@sub.parent_obj}" )

						format.html {
							set_flash "Subscribed", :success
							redirect_back( fallback_location: '/' )
						}
						format.js { render 'create' }
					else
						format.html {
							set_flash "Unable to subscribe", :error
							redirect_back( fallback_location: '/' )
						}
						format.js { render 'create' }
				  end
				end
			end

		end


		def destroy
			@sub = Subscription.where( user: current_user ).find( params[:id] )

			respond_to do |format|
				if @sub.present? && @sub.active? && @sub.trash!
						format.html {
							set_flash "Unsubscribed", :success
							redirect_back( fallback_location: '/' )
						}
					format.js { render 'destroy' }
				else
					format.html {
						set_flash "Could not unsubscribe", :error
						redirect_back( fallback_location: '/' )
					}
					format.js { render 'destroy' }
				end
			end

		end

		def show
			# wtf - http delete method doesn't work????
			destroy
		end


		def update
			@sub = Subscription.where( user: current_user ).find( params[:id] )

			@sub.attributes = params.require( :subscription ).permit( :mute, :availability, :status )

			respond_to do |format|
				if @sub.save
						format.html {
							set_flash "Success", :success
							redirect_back( fallback_location: '/' )
						}
					format.js { render 'update' }
				else
					format.html {
						set_flash "Error", :error
						redirect_back( fallback_location: '/' )
					}
					format.js { render 'update' }
				end
			end

		end

		def widget
			@subscription_widgets = []
			if params[:subscription_widgets]
				params[:subscription_widgets].each do |index,subscription_widget|
					parent_obj = subscription_widget[:parent_obj_type].constantize.find(subscription_widget[:parent_obj_id])
					@subscription_widgets << {
						parent_obj: parent_obj,
						selector: subscription_widget[:selector],
						args: (subscription_widget.permit(:args => {}) || { args: {} })[:args].to_h.symbolize_keys,
					}
				end
			else
				parent_obj = params[:parent_obj_type].constantize.find(params[:parent_obj_id])
				@subscription_widgets << {
					parent_obj: parent_obj,
					selector: params[:selector],
					args: (params.permit(:args => {}) || { args: {} })[:args].to_h.symbolize_keys,
				}
			end
		end


		def index
			# huh?
			create
		end

	end

end

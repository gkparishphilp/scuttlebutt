module Scuttlebutt

	class OptinsController < ApplicationController

		def create
			@user = User.find_or_create_by( email: params[:message][:email].downcase )
			@user.attributes = optin_params

			if @user.save

				@message = 'Success'

				log_event( { user: @user, name: 'email_optin', content: "opted into the email list" } )

				respond_to do |format|
					format.js {
						render :create
					}
					format.json {
						render :create
					}
					format.html {
						if params[:action] == 'back'
							set_flash( @message ) if @message
							redirect_back( fallback_location: thank_you_optins_path )
						else
							redirect_to thank_you_optins_path
						end
					}
				end
			else
				@message = "Couldn't sign up #{@user.email}"
				@success = false

				respond_to do |format|
					format.js {
						render :create
					}
					format.json {
						render :create
					}
					format.html {
						set_flash @message, :error
						redirect_back( fallback_location: root_path )
					}
				end

			end

		end

		private
			def optin_params
				params.require( :message ).permit( :full_name, :first_name, :last_name )
			end
	end
end

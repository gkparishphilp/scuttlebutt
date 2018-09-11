module Scuttlebutt
	
	class OptinsController < ApplicationController
		@user = User.find_or_create_by_email( params[:message][:email] )
		@user.full_name = params[:message][:name]

		if @user.save
			log_event( { name: 'email_optin', content: "opted into the email list" } )
			respond_to do |format|
				format.js {
					render :create
				}
				format.json {
					render :create
				}
				format.html {
					if params[:action] == 'back'
						set_flash @message
						redirect_back( fallback_location: thank_you_optins_path
					else
						redirect_to thank_you_optins_path
					end
				}
			end
		else

		end

	end

	private
		def optin_params
			params.require( :message ).permit( :email, :name )
		end
end
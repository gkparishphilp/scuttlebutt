module Scuttlebutt
	class ContactsController < ApplicationController

		def create
			@user = User.find_or_create_by_email( params[:message][:email] )
			@user.full_name = params[:message][:name]
			if @user.save
				@message = Message.new( message_params )
				@message.sender = @user
				@message.save
				Scuttlebutt::ContactMailer.new_contact( @message ).deliver if Scuttlebutt.contact_email_to.present?

				redirect_to thank_you_contacts_path
			else
				set_flash 'There was a problem...', :danger, @user
				redirect_back( fallback_location: root_path )
			end

		end


		private
			def contact_params
				params.require( :message ).permit( :title, :content, :email, :name )
			end



	end
end
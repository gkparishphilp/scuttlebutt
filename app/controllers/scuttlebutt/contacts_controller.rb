module Scuttlebutt
	class ContactsController < ApplicationController

		def create
			@user = User.find_or_create_by( email: params[:contact][:email] )
			@user.full_name = params[:contact][:name]
			if @user.save
				@contact = Contact.new( contact_params )
				@contact.sender = @user
				@contact.save
				Scuttlebutt::ContactMailer.new_contact( @contact ).deliver if Scuttlebutt.contact_email_to.present?

				redirect_to thank_you_contacts_path
			else
				set_flash 'There was a problem...', :danger, @user
				redirect_back( fallback_location: root_path )
			end

		end


		private
			def contact_params
				params.require( :contact ).permit( :title, :content, :email, :name )
			end



	end
end

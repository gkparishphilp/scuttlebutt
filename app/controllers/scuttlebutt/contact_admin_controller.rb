module Scuttlebutt
	class ContactAdminController < ApplicationAdminController

		before_action :get_contact, except: [ :index ]

		def index
			sort_by = params[:sort_by] || 'created_at'
			sort_dir = params[:sort_dir] || 'desc'

			@contacts = Contact.order( "#{sort_by} #{sort_dir}" )

			if params[:status].present? && params[:status] != 'all'
				@contacts = eval "@contacts.#{params[:status]}"
			end

			@contacts = @contacts.page( params[:page] )
		end

		def edit
			
		end

		def update
			@contact.attributes = contact_params

			authorize( @contact )

			if @contact.save
				set_flash 'Contact Updated '
				redirect_to edit_contact_admin_path( id: @contact.id )
			else
				set_flash 'Contact could not be Updated', :error, @contact
				render :edit
			end
		end

		private
			def contact_params
				params.require( :contact ).permit( :status )
			end

			def get_contact
				@contact = Contact.find( params[:id] )
			end



	end
end
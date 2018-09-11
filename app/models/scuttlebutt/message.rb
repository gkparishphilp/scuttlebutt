module Scuttlebutt
	class Message < ApplicationRecord

		belongs_to :recipient, class_name: 'User', optional: true
		belongs_to :sender, class_name: 'User', optional: true

		attr_accessor :email, :name

		enum status: { 'unnoticed' => 1, 'unread' => 2, 'read' => 3, 'archived' => 4, 'trash' => 5 }

		def self.active
			where( status: [1,2,3] )
		end

		def unread?
			super() || unnoticed?
		end

		def active?
			unnoticed? || unread? || read?
		end

	end
end

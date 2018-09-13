module Scuttlebutt
	class Subscription < ApplicationRecord

		enum status: { 'active' => 1, 'trash' => -50 }
		enum availability: { 'anyone' => 1, 'just_me' => 3 }

		belongs_to	:user
		belongs_to	:parent_obj, polymorphic: true

		def self.muted
			where.not( mute: false, status: 'active' )
		end

		def self.vocal
			where( mute: false, status: 'active' )
		end

	end
end

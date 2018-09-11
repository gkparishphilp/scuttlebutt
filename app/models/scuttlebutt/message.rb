module Scuttlebutt

	class Message < ApplicationRecord

		belongs_to :user, optional: true
		belongs_to :sender, class: 'User'

	end

end

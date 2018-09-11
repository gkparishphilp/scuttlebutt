module Scuttlebutt

	class Notification < ApplicationRecord
		belongs_to :user
		belongs_to :actor, class_name: 'User'
		belongs_to :parent_obj, polymorphic: true
		belongs_to :activity_obj, polymorphic: true
	end

end

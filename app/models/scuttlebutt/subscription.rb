module Scuttlebutt

	class Subscription < ApplicationRecord
		belongs_to :user
		belongs_to :parent_obj, polymorphic: true
		belongs_to :category
	end

end

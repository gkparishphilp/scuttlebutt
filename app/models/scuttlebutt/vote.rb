module Scuttlebutt

	class Vote < ApplicationRecord
		belongs_to :user
		belongs_to :parent_obj, polymorphic: true
	end

end

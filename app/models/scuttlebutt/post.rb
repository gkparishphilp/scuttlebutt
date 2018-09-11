module Scuttlebutt

	class Post < ApplicationRecord
		belongs_to :user
		belongs_to :parent_obj, polymorphic: true
		belongs_to :parent_obj, class_name: 'Scuttlebutt::Post'

	end

end

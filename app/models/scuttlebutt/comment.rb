module Scuttlebutt
	class Comment < Scuttlebutt::Post
		include Scuttlebutt::CommentSearchable if (Scuttlebutt::CommentSearchable rescue nil)
	end
end

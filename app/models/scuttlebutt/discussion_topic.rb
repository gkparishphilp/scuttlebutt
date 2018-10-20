module Scuttlebutt
	class DiscussionTopic < Post

		include Pulitzer::Concerns::URLConcern

		mounted_at "/#{Scuttlebutt.discussion_topic_path}"

		def discussion
			Discussion.find_by( id: self.parent_obj_id )
		end

		def last_post
			last = self.posts.order( created_at: :desc ).last
			last ||= self
			return last
		end

		def paginated_page( dir='asc', per_page=25 ) # todo -- finish implementing reverse
			priors = DiscussionTopic.active.where( parent_obj_id: self.parent_obj_id ).where( "created_at < :my_created_at", my_created_at: self.created_at ).count
			page = ( priors / per_page ) + 1
		end

		def posts
			DiscussionPost.where( parent_obj_id: self.id, parent_obj_type: self.class.name )
		end

		def preview
			self.subject
		end

		def root_parent_obj
			self
		end

		def to_s
			self.subject
		end

	end
end

module Scuttlebutt
	class Post < ApplicationRecord

		before_save	:set_cached_counts, :update_content_hash

		enum status: { 'trash' => -50, 'removed' => -20, 'to_moderate' => -10, 'draft' => 0, 'active' => 1 }
		enum availability: { 'anyone' => 1, 'just_me' => 3 }

		validate 				:check_duplicates
		validates_presence_of 	:content, if: :validate_presence_of_content?

		attr_accessor	:allow_blank_content


		belongs_to :user
		belongs_to :actor, class_name: 'User', optional: true
		belongs_to :parent_obj, polymorphic: true

		has_many 		:replies, class_name: Post.name, foreign_key: 'reply_to_id', inverse_of: :reply_to
		belongs_to 		:reply_to, class_name: Post.name, inverse_of: :replies, optional: true

		has_many_attached :embedded_attachments

		acts_as_taggable_array_on :tags

		include FriendlyId
		friendly_id :slugger, use: :slugged

		def char_count
			return 0 if self.content.blank?
			self.sanitized_content.size
		end

		def compute_content_hash
			Digest::SHA1.hexdigest(self.content || '')
		end

		def mentions_csv
			self.mentions.join(',')
		end

		def mentions_csv=(str)
			self.mentions = str.split(',').collect(&:strip)
		end

		def self.not_reply
			where( reply_to_id: nil )
		end

		def self.reply
			where.not( reply_to_id: nil )
		end

		def reply?
			not( reply_to_id.nil? )
		end

		def root_parent_obj
			if self.parent_obj.nil?
				self
			elsif self.parent_obj.is_a? Scuttlebutt::Post
				self.root_parent_obj
			else
				self.parent_obj
			end
		end

		def root_user_post
			if reply?
				reply_to.root_user_post || reply_to
			else
				nil
			end
		end

		def sanitize_content
			ActionView::Base.full_sanitizer.sanitize( self.content, tags: Scuttlebutt.post_allowed_tags, attributes: Scuttlebutt.post_allowed_attributes )
		end

		def self.term_search( term )
			posts = self
			posts = posts.where( "subject ILIKE :q OR content ILIKE :q", q: "%#{term.gsub('%','\\\\%')}%" ) if term.present?
			posts
		end

		def word_count
			return 0 if self.content.blank?
			self.sanitized_content.scan(/[\w-]+/).size
		end

		def self.within_last( period=1.minute )
			period_ago = Time.zone.now - period
			where( "created_at >= ?", period_ago )
		end

		def self.has_content
			where("((content = '') IS FALSE)")
		end

		def self.no_content
			where.not("((content = '') IS FALSE)")
		end

		def self.order_has_content_desc
			order( "((content = '') IS FALSE) DESC" )
		end

		def self.order_has_content_asc
			order( "((content = '') IS FALSE) ASC" )
		end

		def tags_csv
			self.tags.join(',')
		end

		def tags_csv=(str)
			self.tags = str.split(',').collect(&:strip)
		end

		def to_s
			"#{self.user}'s comment on #{self.parent_obj.to_s}"
		end

		def url( args={} )
			self.parent_obj.url( args ) + "##{self.class.name.to_s.demodulize}_#{self.id}"
		end


		protected

			def validate_presence_of_content?
				not( self.allow_blank_content ) && self.content_changed?
			end

		private

			def update_content_hash
				self.content_hash = compute_content_hash if self.respond_to?( :content_hash )
			end

			def set_cached_counts
				if self.respond_to?( :cached_word_count )
					self.cached_word_count = self.word_count
				end

				if self.respond_to?( :cached_char_count )
					self.cached_char_count = self.char_count
				end
			end

			def check_duplicates
				if self.persisted? || self.content.blank?
					check_query = Post.none
				else

					if self.respond_to?( :content_hash )

						check_query = Post.where( parent_obj_id: self.parent_obj_id, parent_obj_type: self.parent_obj.class.name, user_id: self.user_id, content_hash: self.compute_content_hash ).within_last( 1.minute )

					else

						check_query = Post.where( parent_obj_id: self.parent_obj_id, parent_obj_type: self.parent_obj.class.name, user_id: self.user_id, content: self.content ).within_last( 1.minute )

					end

				end

				if check_query.present?
					self.errors.add :content, "Duplicate"
					return false
				end
			end

			def slugger
				self.subject.blank? ? self.id : self.subject
			end
	end
end

module Scuttlebutt
	mattr_accessor :discussion_path
	mattr_accessor :discussion_topic_path
	mattr_accessor :post_allowed_tags
	mattr_accessor :post_allowed_attributes

		self.discussion_path = 'discussions'

		self.discussion_topic_path = 'topics'

		self.post_allowed_tags = %w( strong table tr td thead tbody i em p div a img alt )

		self.post_allowed_attributes = %w( class href src style )

	# this function maps the vars from your app into your engine
     def self.configure( &block )
        yield self
     end

	class Engine < ::Rails::Engine
		isolate_namespace Scuttlebutt
	end
end

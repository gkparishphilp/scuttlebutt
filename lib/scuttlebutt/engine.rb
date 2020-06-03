module Scuttlebutt

	require 'devise'

	class << self
		mattr_accessor :discussion_path
		self.discussion_path = 'discussions'

		mattr_accessor :discussion_topic_path
		self.discussion_topic_path = 'topics'

		mattr_accessor :post_allowed_tags
		self.post_allowed_tags = %w( strong table tr td thead tbody i em p div a img alt )

		mattr_accessor :post_allowed_attributes
		self.post_allowed_attributes = %w( class href src style )

	end

	# this function maps the vars from your app into your engine
     def self.configure( &block )
        yield self
     end

	class Engine < ::Rails::Engine
		isolate_namespace Scuttlebutt
	end
end

module Scuttlebutt

	class << self
		mattr_accessor :discussion_path
		self.discussion_path = 'discussions'

		mattr_accessor :discussion_topic_path
		self.discussion_topic_path = 'topics'

	end

	# this function maps the vars from your app into your engine
     def self.configure( &block )
        yield self
     end

	class Engine < ::Rails::Engine
		isolate_namespace Scuttlebutt
	end
end

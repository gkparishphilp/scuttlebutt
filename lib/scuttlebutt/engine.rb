module Scuttlebutt

	class << self
		#mattr_accessor :app_description

		#self.app_description = 'A Very Swell App indeed'

	end

	# this function maps the vars from your app into your engine
     def self.configure( &block )
        yield self
     end

	class Engine < ::Rails::Engine
		isolate_namespace Scuttlebutt
	end
end

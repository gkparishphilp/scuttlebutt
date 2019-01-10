module Scuttlebutt
	module DiscussionTopicSearchable
		extend ActiveSupport::Concern

		included do
			include Searchable

			settings index: { number_of_shards: 1 } do
				mappings dynamic: 'false' do
					indexes :id, type: 'integer'
					indexes :created_at, type: 'date'
					indexes :subject, analyzer: 'english', index_options: 'offsets'
					indexes :rating, type: 'integer'
					indexes :status
				end
			end
		end

		module ClassMethods
			# def class_method_name ... end
		end

		# Instance Methods
		# def instance_method_name ... end

	end

end

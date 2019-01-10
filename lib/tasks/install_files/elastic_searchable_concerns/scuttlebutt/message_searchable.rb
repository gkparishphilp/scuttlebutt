module Scuttlebutt
	module MessageSearchable
		extend ActiveSupport::Concern

		included do
			include Searchable

			settings index: { number_of_shards: 1 } do
				mappings dynamic: 'false' do
					indexes :id, type: 'integer'
					indexes :recipient_id, type: 'integer'
					indexes :sender_id, type: 'integer'
					indexes :created_at, type: 'date'
					indexes :title, analyzer: 'english', index_options: 'offsets'
					indexes :content, analyzer: 'english', index_options: 'offsets'
					indexes :public, type: 'boolean'
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

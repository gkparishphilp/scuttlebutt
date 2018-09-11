module Scuttlebutt

	class PostWorker

		if defined?( Sidekiq::Worker )

			include Sidekiq::Worker
			sidekiq_options retry: 1, :queue => :medium

		end

		def perform( user_post_id, args )

			begin

				user_post = Post.find( post_id )

				user_post.mentions = ( ActionController::Base.helpers.sanitize(user_post.content || '', tags: %w()) || '' ).scan(/\B(@[a-z0-9_-]+)/i).collect(&:first).uniq

				user_post.save if user_post.changed?

			rescue Exception => e
				NewRelic::Agent.notice_error(e)
				raise e
			end

		end


		def self.perform_async_if_possible( post_id, args = {} )

			if self.respond_to? :perform_async
				self.perform_async( post_id, args )
			else
				self.new.perform( post_id, args )
			end

		end


	end

end
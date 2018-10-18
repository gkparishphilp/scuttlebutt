class ScuttlebuttSanitizedContentMigration < ActiveRecord::Migration[5.1]

	def change

		add_column :scuttlebutt_posts, :sanitized_content, :text, default: nil
		
	end

end

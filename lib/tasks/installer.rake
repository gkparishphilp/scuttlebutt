# desc "Explaining what the task does"
namespace :scuttlebutt do
	task :install do
		puts "Installing SCuttlebutt. What's Up?"

		files = {
					
		}

		files.each do |filename, path|
			puts "installing: #{path}/#{filename}"

			source = File.join( Gem.loaded_specs["scuttlebutt"].full_gem_path, "lib/tasks/install_files", filename )
    		if path == :root
    			target = File.join( Rails.root, filename )
    		else
    			target = File.join( Rails.root, path, filename )
    		end
    		FileUtils.cp_r source, target
		end


		# migrations

		FileUtils::mkdir_p( File.join( Rails.root, 'db/migrate/' ) )


		migrations = [
			'scuttlebutt_migration.rb',
		]

		prefix = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i

		migrations.each do |filename|

			puts "installing: db/migrate/#{prefix}_#{filename}"

			source = File.join( Gem.loaded_specs["scuttlebutt"].full_gem_path, "lib/tasks/install_files", filename )

    		target = File.join( Rails.root, 'db/migrate', "#{prefix}_#{filename}" )

    		FileUtils.cp_r source, target
    		prefix += 1
		end

	end

end
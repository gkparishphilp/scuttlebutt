$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "scuttlebutt/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "scuttlebutt"
  s.version     = Scuttlebutt::VERSION
  s.authors     = ["Gk Parish-Philp", "Michael Ferguson"]
  s.email       = ["gk@gkparishphilp.com"]
  s.homepage    = "http://gkparishphilp.com"
  s.summary     = "Scuttlebutt."
  s.description = "Scuttlebutt."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_development_dependency "sqlite3"
end

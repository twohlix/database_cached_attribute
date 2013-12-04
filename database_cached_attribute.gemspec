$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "database_cached_attribute/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "database_cached_attribute"
  s.version     = DatabaseCachedAttribute::VERSION
  s.authors     = ["Charles Smith"]
  s.email       = ["charles@balconyinfive.com"]
  s.homepage    = "http://github.com/twohlix/database_cached_attribute/"
  s.summary     = "ActiveRecord Concern to make db caching on ActiveRecord Models simpler"
  s.description = "Provides simple methods on an ActiveRecord model using an ActiveRecord concern to invalidate/save single_column caches."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "temping"
end

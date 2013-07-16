# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "planify/version"

Gem::Specification.new do |gem|
  gem.name          = "planify"
  gem.version       = Planify::VERSION
  gem.authors       = ["Kyle Dayton"]
  gem.email         = ["kyle@graphicflash.com"]
  gem.homepage      = "http://github.com/kdayton-/planify"

  gem.description   = %q{A Mongoid plugin for managing subscription plans and features}
  gem.summary       = gem.description

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "mongoid", ">= 3.0.0"
  gem.add_dependency "active_support"

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "database_cleaner"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.14"
  gem.add_development_dependency "pry"
end

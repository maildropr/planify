source "https://rubygems.org"
gemspec

gem "rake"

group :test do
  gem "rspec", "~> 2.14"
  gem "pry"
  gem "simplecov", require: false

  if ENV["CI"]
    gem "coveralls", require: false
  end
end

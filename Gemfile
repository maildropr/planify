source "https://rubygems.org"
gemspec

group :development, :test do
  gem "rake"
  gem "activesupport"
  gem "actionpack"
end

group :test do
  gem "rspec", "~> 2.14"
  gem "pry"
  gem "simplecov", require: false

  if ENV["CI"]
    gem "coveralls", require: false
  end
end

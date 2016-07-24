# Use single quotes to match the Gemfile Rails generates
gem 'capistrano-rails', :group => 'development'
gem 'foreigner'
gem 'kaminari'
gem 'shoulda-matchers', :group => 'test'

gem_group :development, :test do
  gem 'factory_girl'
  gem 'rspec-rails'
end

environment "config.active_record.timestamped_migrations = false"
environment "config.time_zone = 'Eastern Time (US & Canada)'"

run "rm README.rdoc"

generate "rspec:install"

# Use single quotes to match the Gemfile Rails generates
gem 'kaminari'
gem 'shoulda-matchers', :group => 'test'

gem_group :development do
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
end

gem_group :development, :test do
  gem 'factory_girl'
  gem 'rspec-rails'
end

environment "config.active_record.timestamped_migrations = false"
environment "config.time_zone = 'Eastern Time (US & Canada)'"

run "rm -f README.rdoc"

after_bundle do
  run "cap install"
  generate "rspec:install"
end

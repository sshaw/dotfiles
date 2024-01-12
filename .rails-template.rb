# Use single quotes to match the Gemfile Rails generates
gem 'kaminari'
gem_group :test do
  gem 'shoulda-matchers'
  gem 'super_diff'
end

gem_group :development do
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'gistory'
  gem 'pry-toys'
end

gem_group :development, :test do
  gem 'fabrication'
  gem 'rspec-rails'
end

environment "config.time_zone = 'Eastern Time (US & Canada)'"
environment "config.colorize_logging = false", :env => "production"

run "rm -f README.*"
# Keep local history file; loaded by my ~/.irbrc
run "touch .irb-history"

after_bundle do
  run "cap install"
  run "wget -O- -q https://www.gitignore.io/api/rails > .gitignore"

  generate "rspec:install"
  append_to_file "spec/rails_helper.rb", <<-SHOULDA.strip_heredoc

    Shoulda::Matchers.configure do |config|
      config.integrate do |with|
        with.test_framework :rspec
        with.library :rails
      end
    end
  SHOULDA
end

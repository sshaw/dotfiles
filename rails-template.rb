gem "foreigner"
gem "capistrano"
gem "haml"
gem "shoulda-matchers"
gem "factory_girl"
gem "will_paginate"

environment "config.active_record.timestamped_migrations = false"
environment "config.time_zone = 'Eastern Time (US & Canada)'"

run "rm README.rdoc"

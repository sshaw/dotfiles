gem "foreigner"
gem "capistrano"
gem "haml"
gem "shoulda"
gem "factory_girl"
gem "formtastic"
gem "will_paginate"

environment "config.active_record.timestamped_migrations = false"
environment "config.time_zone = 'Pacific Time (US & Canada)'"

run "mkdir test/factories"
run "rm public/index.html"
# older versions only
# run "rm public/images/rails.png"

# newer versions
run "rm README.rdoc"
run "rm app/assets/images/rails.png"



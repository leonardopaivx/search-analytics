source 'https://rubygems.org'

ruby '3.4.5'

# Core
gem 'rails', '~> 8.0.2'
gem 'pg',    '~> 1.5'
gem 'puma',  '>= 6.0'

# Assets / JS / CSS
gem 'propshaft'
gem 'importmap-rails'
gem 'tailwindcss-rails'
gem 'jbuilder'

# Solid adapters (cache, queue, cable)
gem 'solid_cache'
gem 'solid_queue'
gem 'solid_cable'

# Misc
gem 'bootsnap', require: false
gem 'kamal',    require: false
gem 'thruster', require: false
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'rspec-rails',            '~> 6.1'
  gem 'factory_bot_rails',      '~> 6.5'
  gem 'faker',                  '~> 3.5'
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'brakeman',               require: false
  gem 'rubocop-rails-omakase',  require: false
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner-active_record', '~> 2.2'
end

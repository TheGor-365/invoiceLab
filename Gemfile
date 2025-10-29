source "https://rubygems.org"

gem "rails", "~> 8.1.1"
gem "sprockets-rails"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"
gem "prawn", "~> 2.5"
gem "prawn-table", "~> 0.2.2"
gem "jbuilder"
gem "redis", ">= 4.0.1"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "image_processing", "~> 1.2"
gem "vite_rails", "~> 3.0"
gem "devise", "~> 4.9"
gem "turbo-rails"
gem "sidekiq", "~> 7.2"
gem "sidekiq-cron"
gem "sassc-rails"
gem "stripe", "~> 10.0"
# gem "kredis"
# gem "bcrypt", "~> 3.1.7"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem 'dotenv-rails'
end

group :development do
  gem "web-console"
  gem "letter_opener_web"
  gem "i18n-tasks", "~> 1.0", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

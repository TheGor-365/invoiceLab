source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.2"
gem "sprockets-rails"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"
gem "jbuilder"
gem "redis", ">= 4.0.1"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "image_processing", "~> 1.2"
gem "vite_rails", "~> 3.0"
gem "devise", "~> 4.9"
gem "turbo-rails"
gem "sidekiq", "~> 7.2"
gem "sassc-rails"
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
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

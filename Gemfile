source "https://rubygems.org"

gem "rails", "~> 8.1.4"

# Modern Rails 8 asset pipeline
gem "propshaft"
gem "dartsass-rails"   # Dart Sass compiler for SCSS (better than sassc-rails)

# Database
gem "sqlite3", ">= 2.1"

# Web server
gem "puma", ">= 5.0"

# Frontend JS
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# Bootstrap (via SCSS + Dart Sass)
gem "bootstrap", "~> 5.3"

# Authentication
gem "devise"

# JSON APIs
gem "jbuilder"

# Windows timezone support
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Active Job, Cache, Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Performance
gem "bootsnap", require: false

# Optional deployment/production gems
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 2.2"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

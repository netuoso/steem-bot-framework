source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'

gem 'thin'

gem 'sass-rails', '~> 5.0'
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'twitter-bootstrap-rails'
gem 'bootstrap-multiselect-rails'
gem 'dotenv-rails'

gem 'pundit'
gem 'devise'
gem 'devise-bootstrap-views'

gem 'config'
gem 'paper_trail'
gem 'rails_admin'

gem 'radiator'
gem 'steem_api'

gem 'sucker_punch'

group :development, :test do
  gem 'pry-byebug'
  gem 'thin-rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'puma', '~> 3.7'
end

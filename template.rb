# http://guides.rubyonrails.org/rails_application_templates.html
# https://github.com/morizyun/rails4_template/blob/master/app_template.rb
# https://github.com/search?q=rails%20template&source=c

require 'bundler'

run 'mv README.rdoc README.md'

append_file 'Gemfile', <<-EOS

gem "twitter-bootstrap-rails"

gem 'devise'
gem "kaminari"

gem 'rails_admin'

group :development, :test do
  gem "rspec"
  gem "rspec-rails"
  gem 'simplecov'     , require: false
  gem 'simplecov-rcov', require: false
  gem "pry-rails"
  gem "pry-byebug"
  gem "pry-stack_explorer"
  gem "fuubar"
  gem "factory_girl"
  gem "factory_girl_rails"
  gem "annotate"
  gem "rails_best_practices"
end

group :development do
  gem "better_errors"
  gem 'binding_of_caller'

  gem "schema_comments"
end

EOS



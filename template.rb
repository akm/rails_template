require 'bundler'

run 'mv README.rdoc README.md'

append_file 'Gemfile', <<-EOS

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
end

EOS



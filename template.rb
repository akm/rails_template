# coding: utf-8
# http://guides.rubyonrails.org/rails_application_templates.html
# https://github.com/morizyun/rails4_template/blob/master/app_template.rb
# https://github.com/search?q=rails%20template&source=c

require 'bundler'

def git_add_commit(msg, path = '.')
  git add: path
  git commit: "-m '#{msg}'"
end

def generate_with_git(arg)
  generate arg, '-f'
  git_add_commit "rails generate #{arg}"
end

git :init
git_add_commit "#{File.basename($PROGRAM_NAME)} #{ARGV.join(' ')}"

run 'mv README.rdoc README.md'

git_add_commit "Rename README.rdoc to README.md"

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

git_add_commit 'Add gems to Gemfile'

Bundler.with_clean_env do
  run 'bundle install'
end

git_add_commit 'bundle install'

# set config/application.rb
application  do
  %q{
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    I18n.enforce_available_locales = true
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja

    config.generators do |g|
      # g.orm             :mongoid
      g.test_framework  :rspec
      g.factory_girl dir: 'spec/factories'
      # g.template_engine :haml
    end
  }
end

git_add_commit 'Add settings of timezone, locale and generators'

# set Japanese locale
locale_file_url = "https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml"
run 'wget #{locale_file_url} -P config/locales/'

git_add_commit "Download ja.yml from #{locale_file_url}"

## rspec
generate_with_git 'rspec:install'

## twitter-bootstrap-rails
generate_with_git 'bootstrap:install static'
generate_with_git 'bootstrap:layout'

## kaminari
generate_with_git 'kaminari:views bootstrap3'

## Devise
generate_with_git 'devise:install'

insert_into_file 'app/views/layouts/application.html.erb', <<EOS , after: '<body>'
  <p class="notice"><%= notice %></p>
  <p class="alert"><%= alert %></p>

EOS

insert_into_file 'config/environments/development.rb', <<EOS, after: 'config.action_mailer.raise_delivery_errors = false'

  # for devise
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
EOS

insert_into_file 'config/routes.rb', <<EOS, after: 'Rails.application.routes.draw do'

  root to: "top#index" # TODO create controller for root

EOS

git_add_commit 'Following instructions of devise:install'

generate_with_git 'devise User'

## rails_admin
generate_with_git 'rails_admin:install'

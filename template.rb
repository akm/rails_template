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

def git_run(cmd)
  run cmd
  git_add_commit cmd
end

def download_file(url, dest)
  git_run "curl #{url} -o #{dest}"
end

def git_rake(*args)
  git_run "bin/rake %s" % args.join(" ")
end

git :init
git_add_commit "#{File.basename($PROGRAM_NAME)} #{ARGV.join(' ')}"

run 'mv README.rdoc README.md'

git_add_commit "Rename README.rdoc to README.md"

## Gemfile

gem "twitter-bootstrap-rails"

gem 'devise'
gem "kaminari"

gem 'rails_admin'

gem_group :development, :test do
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

gem_group :development do
  gem "better_errors"
  gem 'binding_of_caller'

  gem "schema_comments"
end

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

# Rails Japanese locale
download_file "https://raw.githubusercontent.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml", "config/locales/ja.yml"

## rspec
generate_with_git 'rspec:install'

## twitter-bootstrap-rails
generate_with_git 'bootstrap:install static'
generate_with_git 'bootstrap:layout'

## kaminari
generate_with_git 'kaminari:views bootstrap3'

## Devise
generate_with_git 'devise:install'
download_file "https://gist.githubusercontent.com/kawamoto/4729292/raw/80fd53034289be926de2e2206c2ab7afbac35993/devise.ja.yml", "config/locales/ja.devise.yml"

insert_into_file 'app/views/layouts/application.html.erb', <<EOS , after: '<body>'
  <p class="notice"><%= notice %></p>
  <p class="alert"><%= alert %></p>

EOS

insert_into_file 'config/environments/development.rb', <<EOS, after: 'config.action_mailer.raise_delivery_errors = false'

  # for devise
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
EOS

insert_into_file 'config/routes.rb', <<EOS, after: 'Rails.application.routes.draw do'

  root to: "rails_admin/main#top" # TODO Change top page

EOS

git_add_commit 'Following instructions of devise:install'

generate_with_git 'devise User'


insert_into_file 'app/models/user.rb', <<EOS, before: 'end'

  class << self
    def current_user=(user)
      Thread.current[:current_user] = user
    end

    def current_user
      Thread.current[:current_user]
    end

    def current(user)
      orig_user, User.current_user = User.current_user, user
      begin
        return yield
      ensure
        User.current_user = orig_user
      end
    end
  end

EOS

# https://github.com/plataformatec/devise/wiki/I18n#japanese-devisejayml
download_file "https://gist.githubusercontent.com/satour/6c15f27211fdc0de58b4/raw/d4b5815295c65021790569c9be447d15760f4957/devise.ja.yml", "config/locales/ja.devise.yml"

## rails_admin
generate_with_git 'rails_admin:install'
download_file "https://raw.githubusercontent.com/starchow/rails_admin-i18n/master/locales/ja.yml", "config/locales/ja.rails_admin.yml"

## DB

git_rake "db:create db:migrate"

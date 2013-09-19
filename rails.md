# Rails 4 + Postgres + RSpec + Devise + Bootstrap + Haml

See postgres.md guide to install and start postgres.

```bash
rails new airship --database=postgresql --skip-test-unit
cd airship
git init
git add .
git commit -m "Init"

# Modify config/database.yml
# Set dev and test database user to 'postgres' or local superuser

# Setup db
rake db:setup
```


RSpec
=====

```bash
# Add rspec gem to Gemfile
group :development, :test do
  gem 'rspec-rails', '~> 2.0'
end

# Install rspec
bundle install
rails generate rspec:install

# Install binstub for convenience
bundle binstubs rspec-core

# Run specs
./bin/rspec
```

Devise
======

```bash
# Add devise gem to Gemfile
gem 'devise'

bundle install
rails generate devise:install

# Follow instructions output during install

# Generate devise model
rails generate devise User
rake db:migrate

# Copy views into rails project
rails generate devise:views users
```


HAML
====

```
# Add haml to Gemfile
gem 'haml-rails'

bundle install

# Convert erb files to haml
find . -name \*.erb -print | sed 'p;s/.erb$/.haml/' | xargs -n2 html2haml

# Remove old erb files
find . -name \*.erb -exec rm {} \;
```


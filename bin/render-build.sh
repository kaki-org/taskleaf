#!/usr/bin/env bash
# exit on error
set -o errexit

#env
bundle install
echo "db:migrate"
bundle exec rails db:migrate
bundle exec rails db:seed

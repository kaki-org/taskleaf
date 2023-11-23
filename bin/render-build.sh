#!/usr/bin/env bash
# exit on error
set -o errexit

#env
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle install

echo "db:migrate"
bundle exec rails db:migrate
bundle exec rails db:seed

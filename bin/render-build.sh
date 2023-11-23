#!/usr/bin/env bash
# exit on error
set -o errexit

#env
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

echo "db:migrate"
bundle exec rails db:migrate
bundle exec rails db:seed

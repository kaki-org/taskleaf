#!/usr/bin/env bash
# exit on error
set -o errexit

#env
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# assets:precompile で vite:build が Node で動くため、Vite 8 の要件（^20.19.0 || >=22.12.0）を満たすか確かめる
node -e '
  const [major, minor] = process.versions.node.split(".").map(Number);
  const ok = (major === 20 && minor >= 19) || (major === 22 && minor >= 12) || major >= 23;
  if (!ok) { console.error(`Node ${process.versions.node} は Vite の要件 (^20.19.0 || >=22.12.0) を満たしません`); process.exit(1); }
  console.log(`Node ${process.versions.node}`);
'

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

echo "db:migrate"
bundle exec rails db:migrate

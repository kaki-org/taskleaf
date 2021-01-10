default: up

init:
	docker-compose build
	docker-compose run -e DISABLE_SPRING=1 --rm web bin/setup

up:
	mkdir -p tmp/pids
	rm -rf tmp/pids/*
	docker-compose up

c:
	docker-compose run --rm web rails c

reset:
	docker-compose run --rm web rails db:migrate:reset db:seed
#	docker-compose run --rm web rails db:migrate:reset db:seed_fu db:seed

rspec:
	docker-compose run -e TZ="/usr/share/zoneinfo/Asia/Tokyo" -e LANG=ja_JP.UTF-8 -e LC_ALL=C.UTF-8 -e LANGUAGE=ja_JP.UTF-8 --rm web bundle exec rspec ${ARG}

rubocop:
	docker-compose run --rm web bundle exec rubocop

erd:
	docker-compose run --rm web bundle exec erd

bundle:
	docker-compose run --rm web bundle install

yarn:
	docker-compose run --rm web yarn install

guard:
	docker-compose run --rm web bundle exec guard


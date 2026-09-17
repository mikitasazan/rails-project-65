lint:
	bundle exec rubocop
	npx herb-lint app/views

lint-fix:
	bundle exec rubocop -A

setup: install build prepare-db

install:
	bundle install
	npm ci

build:
	npm run build
	bin/rails tailwindcss:build

prepare-db:
	bin/rails db:prepare
	bin/rails db:seed

start:
	rm -f tmp/pids/server.pid
	bin/rails server -b 0.0.0.0 -p 3000

test:
	RAILS_ENV=test bin/rails test

check: test lint

ci: setup check

.PHONY: lint lint-fix setup install build prepare-db start test check ci

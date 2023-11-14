# makefile
prepare:
	docker compose up db api react -d
	docker compose exec api bundle exec rake db:migrate:reset
	docker compose exec api bundle exec rake db:seed

frontend:
	docker compose exec react yarn --cwd ./reacting start
backend:
	docker compose exec api foreman start
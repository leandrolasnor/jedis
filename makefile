# makefile
prepare:
	docker compose up api -d
	docker compose exec api bundle exec rake db:migrate:reset
	docker compose exec api bundle exec rake db:seed
run:
	docker compose exec api bundle exec foreman start

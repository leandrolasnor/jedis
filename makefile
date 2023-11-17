# makefile
prepare:
	docker compose up api -d
	docker compose exec api bundle exec rake db:migrate:reset
	docker compose exec api bundle exec rake db:seed
run:
	docker compose exec api bundle exec rails s -b "0.0.0.0" -p 3000
	docker compose exec sidekiq bundle exec sidekiq
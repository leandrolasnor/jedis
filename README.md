# Desafio para Backend - Jedis

Este documento descreve o passo a passo para rodar a aplicação referente ao desafio da vaga de Dev Ruby da Jedis

[Enunciado do problema](https://github.com/leandrolasnor/jedis/blob/master/DESCRIPTION.md)

## Considerações sobre o ambiente

```
# docker-compose.yml
version: '2.22'
services:
  sidekiq:
    image: leandrolasnor/ruby:jedis
    container_name: jedis.sidekiq
    command: sh
    depends_on:
      - redis

  api:
    image: leandrolasnor/ruby:jedis
    container_name: jedis.api
    stdin_open: true
    tty: true
    command: sh
    ports:
      - "3000:3000"
    depends_on:
      - db
      - sidekiq
      - meilisearch

  db:
    image: postgres:16.0
    container_name: jedis.postgresql
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: user
      POSTGRES_DB: jedis
    ports:
      - "5432:5432"

  redis:
    image: redis:alpine
    container_name: jedis.redis
    environment:
      ALLOW_EMPTY_PASSWORD: 'yes'
    ports:
      - "6379:6379"

  meilisearch:
      image: getmeili/meilisearch:latest
      container_name: jedis.meilisearch
      ports:
        - "7700:7700"
      environment:
        MEILI_MASTER_KEY: key
        MEILI_NO_ANALYTICS: true
```

* Uma image docker foi publicada no [Docker Hub](https://hub.docker.com/layers/leandrolasnor/ruby/jedis/images/sha256-03046a84e3dadf16f408ea84d1543530091cc75b0a574b8a220bb1c36307a0bc?context=repo)

#### Conceitos e ferramentas utilizadas na resolução do problema
* Princípio de Inversão de Dependência
* Princípio da Segregação da Interface
* Princípio da responsabilidade única
* Princípio da substituição de Liskov
* Princípio Aberto-Fechado
* Background Processing
* Domain Driven Design
* Código Limpo
* Rubocop
* Bullet
* Dry-rb
* RSpec

## Considerações sobre a aplicação

```
# makefile
prepare:
	docker compose up api -d
	docker compose exec api bundle exec rake db:migrate:reset
	docker compose exec api bundle exec rake db:seed
run:
	docker compose exec api bundle exec rails s -b "0.0.0.0" -p 3000
	docker compose exec sidekiq bundle exec sidekiq
```

* Faça o clone deste repositório ou copie os arquivos `makefile` e `docker-compose.yml` para um pasta na sua máquina

* Use o comando `make prepare` para baixar a imagem e subir os containers _api_, _db_, redis, meilisearch e _sidekiq_

__Nessa etapa as `migrations` foram executadas e o banco de dados se encontra populado com alguns dados__

## Passo a Passo de como executar a solução

* Use o comando `make run` para rodar a aplicação

## Swagger

* Acesse a interface do [`Swagger`](http://localhost:3000/api-docs)
* Verifique o campo `defaultHost` na interface do [`Swagger`](http://localhost:3000/api-docs) e avalie se a url esta correta (_127.0.0.1:3000_ ou _localhost:3000_)

* Nessa interface você poderá validar a documentação dos endpoints e testá-los, enviando algumas requisições http

    - cria pessoa
    - busca por pessoas
    - atualiza os dados de uma pessoa
    - mostra os dados detalhados de uma pessoa

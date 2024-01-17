# Desafio para Backend - Jedis

[Enunciado do problema](https://github.com/leandrolasnor/jedis/blob/master/DESCRIPTION.md)

#### Conceitos e ferramentas utilizadas na resolução do problema
`Docker`

`Ruby on Rails` `Dry-rb` `Sidekiq`

`MeiliSearch` `RSpec` `RSwag` `Redis`

`SOLID` `DDD` `Clear Code` `Clean Arch`

`PostgreSQL`

# .devcontainer :whale:

1. Rode o comando no Visual Code `> Dev Containers: Clone Repository in Container Volume...` e dê `Enter`.
2. Informe a url: `https://github.com/leandrolasnor/jedis` e dê `Enter`
4. :hourglass_flowing_sand: Aguarde até [+] Building **352.7s** (31/31) FINISHED

## Com o processo de build concluido, faça:

* Rode o comando no terminal: `foreman start`

## Swagger

* Acesse a interface do [`Swagger`](http://localhost:3000/api-docs)
* Verifique o campo `defaultHost` na interface do [`Swagger`](http://localhost:3000/api-docs) e avalie se a url esta correta (_127.0.0.1:3000_ ou _localhost:3000_)

* Nessa interface você poderá validar a documentação dos endpoints e testá-los, enviando algumas requisições http

    - cria pessoa
    - busca por pessoas
    - atualiza os dados de uma pessoa
    - mostra os dados detalhados de uma pessoa

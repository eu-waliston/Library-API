# Library API

API RESTful completa para gestão de biblioteca digital com autenticação JWT, autorização, cache, background jobs e muito mais.

## Funcionalidades

- ✅ Autenticação JWT com roles (member, librarian, admin)
- ✅ CRUD completo de livros, autores, categorias
- ✅ Sistema de empréstimos com controle de datas
- ✅ Sistema de reservas
- ✅ Avaliações e reviews
- ✅ Sistema de multas por atraso
- ✅ Notificações por email
- ✅ Background jobs para tarefas periódicas
- ✅ Cache com Redis
- ✅ Documentação Swagger/OpenAPI
- ✅ Testes completos com RSpec
- ✅ Docker e Docker Compose

## Tecnologias

- Ruby on Rails 7 (API mode)
- PostgreSQL
- Redis
- Sidekiq
- JWT
- Pundit (autorização)
- RSpec
- Swagger

## Instalação

### Com Docker (recomendado)

```bash
# Clone o repositório
git clone <repository-url>
cd library_api

# Inicie os containers
docker-compose up -d

# Execute as migrações
docker-compose exec app rails db:create db:migrate db:seed
```
### Sem Docker

```

# Instale as dependências
bundle install
yarn install

# Configure o banco de dados
rails db:create db:migrate db:seed

# Inicie os serviços
redis-server &
bundle exec sidekiq &
rails server

```

### Endpoints Principais

**Autenticação**

  - POST /api/v1/auth/register - Registrar usuário

  - POST /api/v1/auth/login - Login

  - POST /api/v1/auth/logout - Logout

  - GET /api/v1/auth/me - Perfil do usuário

**Livros**

  - GET /api/v1/books - Listar livros (com filtros)

  - GET /api/v1/books/:id - Detalhes do livro

  - POST /api/v1/books - Criar livro (apenas admin/librarian)

  - POST /api/v1/books/:id/borrow - Emprestar livro

  - GET /api/v1/books/recommendations - Recomendações personalizadas

**Empréstimos**

  - GET /api/v1/loans - Meus empréstimos

  - POST /api/v1/loans/:id/return - Devolver livro

## Variáveis de Ambiente

```

DATABASE_URL=postgresql://user:password@localhost:5432/library_api
REDIS_URL=redis://localhost:6379/1
SECRET_KEY_BASE=your_secret_key_base
RAILS_ENV=development

```

## Testes

```

# Rodar todos os testes
bundle exec rspec

# Rodar testes específicos
bundle exec rspec spec/models/book_spec.rb

# Com cobertura de código
COVERAGE=true bundle exec rspec

```

## Documentação da API

**Acesse ```http://localhost:3000/api-docs``` para a documentação Swagger interativa.**

## Background Jobs

Os jobs são gerenciados pelo Sidekiq. Acesse http://localhost:3000/sidekiq (apenas admin) para monitorar.

### Contribuição

1. Fork o projeto

2. Crie uma branch (git checkout -b feature/AmazingFeature)

3. Commit suas mudanças (git commit -m 'Add some AmazingFeature')

4. Push para a branch (git push origin feature/AmazingFeature)

5. Abra um Pull Request

## Licença
Distribuído sob a licença MIT. Veja LICENSE para mais informações.



## Arquivos de Configuração Adicionais

### .env.example
```env
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=library_user
DATABASE_PASSWORD=password
REDIS_URL=redis://localhost:6379/1
SECRET_KEY_BASE=your_secret_key_base_here
RAILS_ENV=development****
```
## .rubocop.yml

```

require:
  - rubocop-rails
  - rubocop-rspec

AllCops:
  NewCops: enable
  TargetRubyVersion: 3.1.2
  Exclude:
    - 'db/**/*'
    - 'bin/*'
    - 'vendor/**/*'
    - 'node_modules/**/*'
    - 'tmp/**/*'

Metrics/BlockLength:
  Exclude:
    - 'spec/**/*'
    - 'config/routes.rb'

Style/Documentation:
  Enabled: false

Layout/LineLength:
  Max: 100

Rails:
  Enabled: true

```

33 Como Executar o Projeto:

```

 # 1- Clone e configure:

git clone <seu-repositorio>
cd library_api
cp .env.example .env
# Edite o .env com suas configurações

# 2. Instale as dependências:

bundle install
yarn install

# 3. Configure o banco de dados:

rails db:create db:migrate db:seed

# 4. Inicie os serviços:

# Em terminais separados:
redis-server
bundle exec sidekiq
rails server

# 5. Teste a API:

# Registre um usuário
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"test@example.com","password":"password","first_name":"John","last_name":"Doe"}}'

# Faça login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'

# Liste livros (use o token retornado)
curl -X GET http://localhost:3000/api/v1/books \
  -H "Authorization: Bearer <seu_token>"

```
## Este projeto cobre:

  - ✅ Arquitetura RESTful completa

  - ✅ Autenticação JWT com diferentes roles

  - ✅ Autorização granular com Pundit

  - ✅ Cache com Redis

  - ✅ Background jobs com Sidekiq

  - ✅ Testes com RSpec

  - ✅ Documentação com Swagger

  - ✅ Dockerização completa

  - ✅ Monitoramento

  - ✅ Validações robustas

  - ✅ Serialização de dados

  - ✅ Paginação

  - ✅ Filtros e busca

  - ✅ Serviços especializados

  - ✅ Jobs periódicos

  - ✅ Sistema de notificações

  - ✅ Relatórios

  - ✅ Configuração de ambiente
   
  - ✅ Linting com Rubocop

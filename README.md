<div align="center">

# 📚 Library API  
### Uma biblioteca digital inteligente, moderna e poderosa

🚀 API RESTful completa para gestão de bibliotecas digitais  
🔐 Segura • ⚡ Performática • 🧠 Escalável • 🐳 Dockerizada  

![Ruby](https://img.shields.io/badge/Ruby-3.1.2-red)
![Rails](https://img.shields.io/badge/Rails-7.0-red)
![Postgres](https://img.shields.io/badge/PostgreSQL-15-blue)
![Redis](https://img.shields.io/badge/Redis-cache-critical)
![Sidekiq](https://img.shields.io/badge/Sidekiq-jobs-orange)
![JWT](https://img.shields.io/badge/Auth-JWT-success)
![RSpec](https://img.shields.io/badge/Tests-RSpec-brightgreen)
![Docker](https://img.shields.io/badge/Docker-ready-blue)

</div>

---

## ✨ Visão Geral

A **Library API** é uma API RESTful robusta criada para gerenciar uma biblioteca digital completa — desde autenticação de usuários até empréstimos, reservas, notificações e jobs em background.

Tudo isso seguindo boas práticas, arquitetura limpa e foco em escalabilidade.  
Código que respira organização. Sistema que flui como poesia 📖✨

---

## 🚀 Funcionalidades

✔️ Autenticação JWT com roles (`member`, `librarian`, `admin`)  
✔️ CRUD completo de livros, autores e categorias  
✔️ Sistema de empréstimos com controle de datas  
✔️ Reservas inteligentes  
✔️ Avaliações e reviews  
✔️ Multas automáticas por atraso  
✔️ Notificações por e-mail  
✔️ Background jobs com Sidekiq  
✔️ Cache com Redis  
✔️ Documentação Swagger/OpenAPI  
✔️ Testes completos com RSpec  
✔️ Docker & Docker Compose  

---

## 🧰 Tecnologias

| Stack | Ferramenta |
|-----|-----------|
| 🧠 Backend | Ruby on Rails 7 (API Mode) |
| 🗄 Banco de Dados | PostgreSQL |
| ⚡ Cache | Redis |
| 🔄 Jobs | Sidekiq |
| 🔐 Auth | JWT |
| 🛂 Autorização | Pundit |
| 🧪 Testes | RSpec |
| 📑 Docs | Swagger |
| 🐳 Infra | Docker |

---

## 🐳 Instalação (Docker – Recomendado)

```bash
git clone <repository-url>
cd library_api

docker-compose up -d
docker-compose exec app rails db:create db:migrate db:seed
```

## 🛠️ Instalação (Sem Docker)

```

bundle install
yarn install

rails db:create db:migrate db:seed

redis-server &
bundle exec sidekiq &
rails server

```
## 🔐 Autenticação
***Endpoints***

| Método | Endpoint              | Descrição         |
| ------ | --------------------- | ----------------- |
| POST   | /api/v1/auth/register | Registrar usuário |
| POST   | /api/v1/auth/login    | Login             |
| POST   | /api/v1/auth/logout   | Logout            |
| GET    | /api/v1/auth/me       | Perfil do usuário |

### 📚 Livros
| Método | Endpoint                      |
| ------ | ----------------------------- |
| GET    | /api/v1/books                 |
| GET    | /api/v1/books/:id             |
| POST   | /api/v1/books                 |
| POST   | /api/v1/books/:id/borrow      |
| GET    | /api/v1/books/recommendations |

### 🔄 Empréstimos
| Método | Endpoint                 |
| ------ | ------------------------ |
| GET    | /api/v1/loans            |
| POST   | /api/v1/loans/:id/return |

### 🌱 Variáveis de Ambiente
```
DATABASE_URL=postgresql://user:password@localhost:5432/library_api
REDIS_URL=redis://localhost:6379/1
SECRET_KEY_BASE=your_secret_key_base
RAILS_ENV=development
```

### 🧪 Testes
```
bundle exec rspec
bundle exec rspec spec/models/book_spec.rb
COVERAGE=true bundle exec rspec
```
****Porque código bonito também precisa ser confiável 💚***

## 📑 Documentação da API
#### 👉 Acesse: ```http://localhost:3000/api-docs```
****Swagger interativo, claro e direto ao ponto.****

## 🤝 Contribuindo

1. Fork o projeto 🍴

2. Crie sua branch:
```
git checkout -b feature/AmazingFeature
```
3. Commit suas mudanças

4. Push para a branch

5. Abra um Pull Request 💜

## 📜 Licença

##### Distribuído sob a licença MIT.
##### Use, modifique, evolua — conhecimento é pra circular 🌍✨

<div align="center">

💡 Código é poesia quando é bem escrito.
Feito com ☕, 🧠 e um pouco de ousadia.

</div> ```

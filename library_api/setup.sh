#!/bin/bash
# setup.sh

echo "=== Library API Setup ==="

# Instalar dependências
echo "Instalando dependências Ruby..."
bundle install

# Instalar dependências Node.js (se necessário)
echo "Instalando dependências Node.js..."
yarn install || npm isntall 

# Configurar banco de dados
echo "Configurando banco de dados..."
rails db:create
rails db:migrate

# Popular banco de dados com dados de exemplo
echo "Populando banco de dados..."
rails db:seed

# Criar diretórios necessários
echo "Criando diretórios..."
mkdir -p tmp/pids tmp/sockets tmp/cache tmp/storage
mkdir -p log

# Configurar pre-commit hooks
echo "Configurando pre-commit hooks..."
cp .githooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "=== Setup completo! ==="
echo "Para iniciar o servidor: rails server"
echo "Para rodar os testes: rspec"
echo "Para acessar a documentação: http://localhost:3000/api-docs"
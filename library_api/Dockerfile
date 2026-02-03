# Dockerfile
FROM ruby:3.1.2-alpine

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    postgresql-client \
    nodejs \
    yarn \
    tzdata \
    git \
    curl \
    bash

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

COPY . .

RUN chmod +x docker-entrypoint.sh

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
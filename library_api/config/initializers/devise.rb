# frozen_string_literal: true

Devise.setup do |config|
  config.secret_key = Rails.application.credentials.secret_key_base
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.secret_key_base
    jwt.dispatch_requests = [
      ['POST', %r{^/api/v1/auth/login$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/api/v1/auth/logout$}]
    ]
    jwt.expiration_time = 24.hours.to_i
  end
end
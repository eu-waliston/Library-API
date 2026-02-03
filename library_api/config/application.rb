require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module LibraryApi
  class Application < Rails::Application
    config.load_defaults 7.0
    config.active_record.default_timezone = :local

    # Timezone
    config.time_zone = 'America/Sao_Paulo'
    config.active_record.default_timezone = :local

    # Locale
    config.i18n.default_locale = :'pt-BR'
    config.i18n.available_locales = [:'pt-BR', :en]

    # Midleware
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 methods: [:get, :post,:patch, :put, :delete, :options, :head],
                 expose: ['Authorization']
      end
    end

    # Auyoload paths
    config.autoload_paths += %W[
      #{config.root}/app/services
      #{config.root}/app/policies
      #{config.root}/app/serializers
      #{config.root}/lib
    ]

    # Cache store
    config.cache_store = :redis_cache_store, {
      url: ENV['REDIS_URL'] || 'redis://localhost:6379/0',
      expires_in: 1.hour,
    }

    # Active Job
    config.active_job.queue_adapter = :sidekiq

    # Loging
    config.log_level = :info
    config.log_tags = [:request_id]
  end
end

# frozen_string_literal: true

module Api
  module V1
    class HealthController < ApplicationController
      skip_before_action :authenticate_user!

      def index
        health_check = {
          status: 'OK',
          timestamp: Time.current.iso8601,
          services: {
            database: database_status,
            redis: redis_status,
            sidekiq: sidekiq_status
          },
          version: '1.0.0',
          uptime: `uptime`.chomp
        }

        render json: health_check
      end

      private

      def database_status
        ActiveRecord::Base.connection.active?
        'OK'
      rescue StandardError => e
        'ERROR'
      end

      def redis_status
        Redis.new.ping
        'OK'
      rescue StandardError => e
        'ERROR'
      end

      def sidekiq_status
        Sidekiq::ProcessSet.new.size > 0 ? 'OK' : 'ERROR'
      rescue StandardError => e
        'ERROR'
      end
    end
  end
end
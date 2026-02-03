# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      include Pundit::Authorization
      before_action :authenticate_user!
      after_action  :verify_authorized, except: :index
      after_action  :verify_policy_scoped, only: :index

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

      private

      def user_not_authorized
        render json: {error: 'You are not authorized to perform this action'}, status: :unauthorized
      end

      def record_not_found(exception)
        render json: {error: exception.message}, status: :not_found
      end

      def record_invalid(exception)
        render json: {
          error: 'Validation failed',
          details: exception.record.errors.full_messages
        }, status: :unprocessable_entity
      end

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count,
          par_page: collection.current_page + 1,
        }
      end
    end
  end
end

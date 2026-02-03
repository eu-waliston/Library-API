# frozen_string_literal: true

module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user!, only: [:login, :register]

      def register
        user = User.new(user_params)
        user.role = :member # default role

        if user.save
          token = generate_token(user)

          render json: {
            user: UserSerializer.new(user),
            auth_token: token,
          }, status: :created
        else
          render json: {errora: user.erros.full_messages}, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by_email(params{:email})

        if user&.valid_password?(params[:password])
          token = generate_token(user)

          render json: {
            user: UserSerializer.new(user),
            token: token,
          }, status: :ok
        else
          render json: {error: "Invalid email or password!"}
        end
      end

      def logout
        token = request.headers["Authorization"]&.split(' ')&.last
        JwtDenylist.create!(jwt: decoded_token['jti'], exp: Time.at(decoded_token['exp']))
        render json: { message: 'Logged out successfully'}, status: :ok
      end

      def me
        render json: current_user, serializer: userSerializer
      end

      private

      def user_params
        params.require(:user).permit(
          :email, :password, :password_confirmation,
          :first_name, :last_name, :phone
        )
      end

      def generate_token(user)
        payload = {
          sub: user.id,
          jti: SecureRandom.uuid,
          iat: Time.current.to_i,
          exp: 24.hours.from_now.to_i,
          role: user.role
        }

        JWT.encode(payload, Rails.aplication.credentials.secret_key_base, 'HS256')
      end

      def decoded_token
        token = request.headers["Authorization"]&.split(' ')&.last
        JWT.decode(token, Rails.configuration.secret_key_base, true, { algorithm: 'HS256' })
      rescue JWT::ExpiredSignature
        nill
      end
    end
  end
end

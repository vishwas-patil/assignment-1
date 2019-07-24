# frozen_string_literal: true

module V1
  module Authorizations
    #:nodoc:
    class RegisterController < ApplicationController
      include JWTAuthenticate
      include Response

      def create
        @user = User.new(user_params)
        if @user.save
          success_response
        else
          unprocessable_entity(@user.errors.full_messages.join(','))
        end
      end

      private

      def user_params
        params.require(:user)
              .permit(:email, :password, :password_confirmation)
      end

      def success_response
        response = {}
        user = @user
        response = auth_headers(response, user)
        @access_token = response[:body]
        render json: success_response_body, status: :created
      end

      def success_response_body
        {
          status: 'Success',
          message: 'User Created Successfully',
          id: @user.id,
          access_token: @access_token[:access_token],
          token_type: 'bearer',
          expires_in: @access_token[:expires_in],
          created_at: @access_token[:created_at]
        }
      end

    end
  end
end

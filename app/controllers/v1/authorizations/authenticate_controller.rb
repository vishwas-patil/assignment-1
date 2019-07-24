# frozen_string_literal: true

module V1
  module Authorizations
    #:nodoc:
    class AuthenticateController < Devise::SessionsController
      include Response
      include JWTAuthenticate

      before_action :authorize_user!, only: :revoke

      def create
        @response = {}
        @user = User.find_by(email: params[:email])
        if resource_owner_from_credentials
          @response = auth_headers(@response, @user)
          @response[:status] = :ok
          sign_in(@user)
        else
          @response[:status] = :unauthorized
        end
        create_response
      end

      def revoke
        user, payload = fetch_user_payload_from_token
        sign_out(user)
        User.revoke_jwt(payload, user)
        successful_response('Successfully Logout User')
      end

      private

      def resource_owner_from_credentials
        user = User.find_for_database_authentication(email: params[:email])
        return if user.blank?

        return_user = ( user&.valid_for_authentication? { user.valid_password?(params[:password]) } )
        user if return_user
      end

      def create_response
        if @user.blank?
          set_error_response('Error', 'Record not found', :not_found)
        elsif @response[:status].to_s == 'unauthorized'
          fetch_unauthorized_response
        else
          set_response(@response[:body], @response[:status])
        end
      end

      def set_response(body, status)
        self.response_body = body.to_json
        self.status = status
      end

      def fetch_unauthorized_response
        unauthorize_msg = 'Email, Password or access token Incorrect'
        @response[:error] = unauthorize_msg if @response[:error].blank?
        set_error_response('invalid_grant', @response[:error], @response[:status])
      end
    end
  end
end

# frozen_string_literal: true

#:nodoc:
module JWTAuthenticate
  def authorize_user!
    user, payload = fetch_user_payload_from_token
    return unless User.jwt_revoked?(payload, user)

    set_error_response(
      'invalid_grant', 'Email, Password or access token Incorrect', :unauthorized
    )
  rescue StandardError
    set_error_response(
      'Error', 'You are not logged in. Please log in first.', :unauthorized
    )
  end

  def current_token
    auth_header = request.env['HTTP_AUTHORIZATION']
    auth_header.split(' ').last
  end

  def fetch_user_payload_from_token
    token = current_token
    payload = decode_token token
    user = User.find_for_jwt_authentication(payload['sub'])
    [user, payload]
  end

  def auth_headers(response, user, scope: nil, aud: nil)
    scope ||= Devise::Mapping.find_scope!(user)
    aud ||= headers[Warden::JWTAuth.config.aud_header]
    token, payload = encode_token(user, scope, aud)
    expiry = payload['exp'] - payload['iat']
    response[:body] = { access_token: token, token_type: 'bearer',
                        expires_in: expiry, created_at: payload['iat'] }
    response
  end

  def encode_token(user, scope, aud)
    Warden::JWTAuth::UserEncoder.new.call(user, scope, aud)
  end

  def decode_token(token)
    Warden::JWTAuth::TokenDecoder.new.call(token)
  end

  def set_error_response(message, description, status)
    self.response_body = {
      status: message,
      message: description
    }.to_json
    self.status = status
  end
end

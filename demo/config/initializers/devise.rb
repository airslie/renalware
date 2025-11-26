Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  # confirmation, reset password and unlock tokens in the database.
  config.secret_key = "abcdff0441bcc45be7f0b05f40c6107fbed63df50eb7023a2aa09237fad4f108b2cc2516e9aa"

  config.omniauth_path_prefix = "/users/auth"
  config.omniauth(
    :entra_id,
    client_id: ENV.fetch("ENTRA_CLIENT_ID", nil),
    client_secret: ENV.fetch("ENTRA_CLIENT_SECRET", nil),
    tenant_id: ENV.fetch("ENTRA_TENANT_ID", nil),
    authorize_params: {
      scope: "openid profile email"
    }
  )
end

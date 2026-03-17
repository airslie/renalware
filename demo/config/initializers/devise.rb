Devise.setup do |config|
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

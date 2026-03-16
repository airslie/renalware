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

  # config.omniauth(
  #   :ldap,
  #   title: "Renalware LDAP",
  #   encryption: "ssl",
  #   host: ENV["LDAP_HOST"] || "localhost",
  #   port: (ENV["LDAP_PORT"] || 389).to_i,
  #   base: ENV["LDAP_BASE"] || "dc=renalware,dc=app",
  #   uid: ENV.dig("LDAP_ATTRIBUTE_MAPPINGS", "username") || "uid",
  #   bind_dn: "#{ENV.fetch('LDAP_ADMIN_USER')},#{ENV.fetch('LDAP_BASE')}",
  #   password: ENV.fetch("LDAP_ADMIN_PASSWORD", nil),
  #   name_proc: proc { |n| n.split("@").first },
  #   tls_options: {
  #     ssl_version: "TLSv1_2",
  #     ciphers: %w(AES-128-CBC AES-128-CBC-HMAC-SHA1 AES-128-CBC-HMAC-SHA256)
  #   }
  # )
end

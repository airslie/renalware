module Relay
  module GPConnect
    module Mesh
      # Everything the MESH classes need to know about the outside world, as one immutable value.
      # The host application builds one (e.g. from its own settings) and passes it in; nothing in
      # this gem reads global configuration.
      #
      # Certificates and keys can each come from a file (*_path) or, if there is no such file,
      # from the contents held in config (e.g. an env var). base_dir is what a relative
      # ca_file_path is resolved against. clock returns the current time, used to timestamp the
      # MESH authorization header; it defaults to UTC now.
      Config = Data.define(
        :mailbox_id,
        :mailbox_password,
        :api_secret,
        :api_base_url,
        :workflow_id,
        :client_cert_path,
        :client_cert,
        :client_key_path,
        :client_key,
        :ca_file_path,
        :ca_cert,
        :base_dir,
        :clock
      ) do
        def initialize(clock: -> { Time.now.utc }, **settings)
          super
        end
      end
    end
  end
end

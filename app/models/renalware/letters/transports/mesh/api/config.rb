module Renalware
  module Letters::Transports::Mesh
    module API
      # Everything the MESH API layer (client, auth header, request headers, urls, certificates)
      # needs to know about the outside world, as one immutable value. The API classes take one of
      # these (defaulting to Config.from_renalware) so they do not reach into Renalware.config
      # themselves, which lets the same code be used outside Renalware.
      #
      # Certificates and keys can each come from a file (*_path) or, if there is no such file,
      # from the contents held in config (e.g. an env var). base_dir is what a relative
      # ca_file_path is resolved against.
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
        :base_dir
      ) do
        # Reads Renalware.config at call time (not at load time), so the values current at the
        # moment the API object is built are the ones used.
        def self.from_renalware # rubocop:disable Metrics/MethodLength
          config = Renalware.config
          new(
            mailbox_id: config.mesh_mailbox_id,
            mailbox_password: config.mesh_mailbox_password,
            api_secret: config.mesh_api_secret,
            api_base_url: config.mesh_api_base_url,
            workflow_id: config.mesh_workflow_id,
            client_cert_path: config.mesh_path_to_client_cert,
            client_cert: config.mesh_client_cert,
            client_key_path: config.mesh_path_to_client_key,
            client_key: config.mesh_client_key,
            ca_file_path: config.mesh_path_to_nhs_ca_file,
            ca_cert: config.mesh_nhs_ca_cert,
            base_dir: Rails.root
          )
        end
      end
    end
  end
end

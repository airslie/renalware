module Renalware
  module Letters::Transports::Mesh
    module API
      # Builds the gem's Mesh::Config from Renalware.config. This is the one place the MESH code
      # reads Renalware's settings.
      module Config
        # Reads Renalware.config when called (not when the class loads), so the values current at
        # the moment a Client is built are the ones used.
        #
        # The clock is Time.zone.now, i.e. London time: the MESH authorization header has always
        # been timestamped in the application's time zone.
        def self.from_renalware # rubocop:disable Metrics/MethodLength
          config = Renalware.config
          Relay::GPConnect::Mesh::Config.new(
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
            base_dir: Rails.root,
            clock: -> { Time.zone.now }
          )
        end
      end
    end
  end
end

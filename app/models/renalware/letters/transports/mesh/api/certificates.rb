# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    module API
      class Certificates
        def client_cert   = OpenSSL::X509::Certificate.new(mesh_certificate(:client_cert))
        def client_key    = OpenSSL::PKey::RSA.new(mesh_certificate(:client_key))
        def ca_file_path  = absolute_ca_file_path.to_s

        private

        # Load the certificate from disk if a configured file path is present and the file exists.
        # For Azure deployments, certs might be in the docker image, or as ENV vars.
        # On Heroku certs will be stored as ENV vars.
        def mesh_certificate(cert_type)
          path = Renalware.config.public_send(:"mesh_path_to_#{cert_type}")
          if path && File.exist?(path)
            File.read(path)
          else
            config_method_name = :"mesh_#{cert_type}"
            Renalware.config.public_send(config_method_name).tap do |cert_content|
              raise(ArgumentError, "Missing config #{config_method_name}") if cert_content.blank?
            end
          end
        end

        # Return an absolute path to the NHA CA (Certificate Authority) certificate, required for
        # our SSL setup.
        #
        # If the file is missing at runtime then create it using the cert content in the CA ENV var
        # and return the path to the file. The configured_ca_path will be relative eg
        # config/certificates/meh/nhs_ca.cert so we make sure to resolve that path relative to
        # Rails root folder (eg ./demo in this project).
        #
        # - In Azure docker deployments, the file might be in the image, or the cert contents in ENV
        # - On Heroku the cert contents will be an ENV var.
        # - In development, the CA cert file likely be an existing file path setup by the developer.
        #   For example we have the location demo/config/certificates/mesh in which I currently have
        #   MESH and CA certs (ignored by git), so this seems like a good location to put them.
        #
        def absolute_ca_file_path
          Rails.root.join(configured_ca_path).tap { |path| create_ca_cert_if_not_exists(path) }
        end

        def create_ca_cert_if_not_exists(path)
          unless File.exist?(path)
            FileUtils.mkdir_p path.dirname
            File.write(path, configured_ca_cert_contents)
          end
        end

        def configured_ca_path
          Renalware.config.mesh_path_to_nhs_ca_file.tap do |path|
            raise(ArgumentError, "Missing config mesh_path_to_nhs_ca_file") if path.blank?
          end
        end

        def configured_ca_cert_contents
          Renalware.config.mesh_nhs_ca_cert.tap do |cert|
            raise(ArgumentError, "Missing config mesh_nhs_ca_cert") if cert.blank?
          end
        end
      end
    end
  end
end

module Renalware
  module Letters::Transports::Mesh
    module API
      class Certificates
        # A well formed PEM starts with a header line such as -----BEGIN CERTIFICATE----- or
        # -----BEGIN RSA PRIVATE KEY-----, followed by a line feed.
        WELL_FORMED_PEM = /\A\s*-----BEGIN [A-Z0-9 ]+-----\s*\n/

        def initialize(config: API::Config.from_renalware)
          @config = config
        end

        def client_cert   = OpenSSL::X509::Certificate.new(mesh_certificate(:client_cert))
        def client_key    = OpenSSL::PKey::RSA.new(mesh_certificate(:client_key))
        def ca_file_path  = absolute_ca_file_path.to_s

        private

        attr_reader :config

        # Load the certificate from disk if a configured file path is present and the file exists.
        # For Azure deployments, certs might be in the docker image, or as ENV vars.
        # On Heroku certs will be stored as ENV vars.
        def mesh_certificate(cert_type)
          path = config.public_send(:"#{cert_type}_path")
          if path.present? && File.exist?(path)
            File.read(path)
          else
            cert_contents = config.public_send(cert_type)
            raise(ArgumentError, "Missing config mesh_#{cert_type}") if cert_contents.blank?

            cert_contents_with_line_feeds_reinstated(cert_contents)
          end
        end

        # Return an absolute path to the NHA CA (Certificate Authority) certificate, required for
        # our SSL setup.
        #
        # If the file is missing at runtime then create it using the cert content in the CA ENV var
        # and return the path to the file. The configured_ca_path will be relative eg
        # config/certificates/meh/nhs_ca.cert so we make sure to resolve that path relative to
        # the configured base_dir (Rails.root in Renalware).
        #
        # - In Azure docker deployments, the file might be in the image, or the cert contents in ENV
        # - On Heroku the cert contents will be an ENV var.
        # - In development, the CA cert file likely be an existing file path setup by the developer.
        #   For example we have the location config/certificates/mesh in which I currently have
        #   MESH and CA certs (ignored by git), so this seems like a good location to put them.
        #
        def absolute_ca_file_path
          config.base_dir.join(configured_ca_path).tap { |path| create_ca_cert_if_not_exists(path) }
        end

        def create_ca_cert_if_not_exists(path)
          unless File.exist?(path)
            FileUtils.mkdir_p path.dirname
            File.write(path, configured_ca_cert_contents)
          end
        end

        def configured_ca_path
          config.ca_file_path.tap do |path|
            raise(ArgumentError, "Missing config mesh_path_to_nhs_ca_file") if path.blank?
          end
        end

        def configured_ca_cert_contents
          cert_contents = config.ca_cert
          raise(ArgumentError, "Missing config mesh_nhs_ca_cert") if cert_contents.blank?

          cert_contents_with_line_feeds_reinstated(cert_contents)
        end

        # If the contents are not well formed PEM (typically because the line feeds have been lost)
        # reinstate them. This happens on Azure: pasting a cert into an ENV var in settings
        # results in \n being replaced with " ".
        #
        # We used to guess this from the position of the first line feed, which wrongly "repaired"
        # a good RSA key as its header (-----BEGIN RSA PRIVATE KEY-----) is longer than a
        # certificate's. Now we look at the shape of the header.
        def cert_contents_with_line_feeds_reinstated(cert_contents)
          return cert_contents if cert_contents.match?(WELL_FORMED_PEM)

          # Replace spaces in the PEM string with \n unless they are the spaces between the words
          # of the header and footer, e.g. BEGIN RSA PRIVATE KEY
          cert_contents.gsub(/ (?!(CERTIFICATE|PRIVATE|KEY|RSA|EC|ENCRYPTED))/, "\n")
        end
      end
    end
  end
end

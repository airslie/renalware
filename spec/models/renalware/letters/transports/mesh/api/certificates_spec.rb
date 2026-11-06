require "tmpdir"

module Renalware::Letters::Transports::Mesh
  describe API::Certificates do
    subject(:certificates) { described_class.new }

    let(:cert_path) { Rails.root.join("spec/support/dummy_mesh_cert.txt") }
    let(:key_path) { Rails.root.join("spec/support/dummy_mesh_key.txt") }
    let(:cert_pem) { File.read(cert_path) }
    let(:key_pem) { File.read(key_path) }
    let(:expected_cert_pem) { OpenSSL::X509::Certificate.new(cert_pem).to_pem }
    let(:tmp_dir) { Dir.mktmpdir }

    def configure(**settings)
      allow(Renalware.config).to receive_messages(
        mesh_path_to_client_cert: nil,
        mesh_client_cert: "",
        mesh_path_to_client_key: nil,
        mesh_client_key: "",
        **settings
      )
    end

    after { FileUtils.remove_entry(tmp_dir) }

    it "client_cert is loaded from the configured file when it exists" do
      configure(mesh_path_to_client_cert: cert_path)

      expect(certificates.client_cert).to be_a(OpenSSL::X509::Certificate)
      expect(certificates.client_cert.to_pem).to eq(expected_cert_pem)
    end

    it "client_cert falls back to the cert contents in config when there is no file" do
      configure(mesh_path_to_client_cert: "/no/such/file", mesh_client_cert: cert_pem)

      expect(certificates.client_cert.to_pem).to eq(expected_cert_pem)
    end

    it "client_cert reinstates line feeds in a cert pasted into an env var with spaces" do
      configure(mesh_client_cert: cert_pem.tr("\n", " ").strip)

      expect(certificates.client_cert.to_pem).to eq(expected_cert_pem)
    end

    it "client_cert raises if there is neither a file nor config contents" do
      configure

      expect { certificates.client_cert }
        .to raise_error(ArgumentError, "Missing config mesh_client_cert")
    end

    it "client_key is loaded from the configured file when it exists" do
      configure(mesh_path_to_client_key: key_path)

      expect(certificates.client_key).to be_a(OpenSSL::PKey::RSA)
    end

    it "client_key falls back to PKCS#8 contents (BEGIN PRIVATE KEY) in config" do
      configure(mesh_client_key: OpenSSL::PKey::RSA.new(key_pem).private_to_pem)

      expect(certificates.client_key).to be_a(OpenSSL::PKey::RSA)
    end

    # KNOWN BUG, deliberately not fixed in the refactoring PRs (it would change behaviour).
    # The line-feed "repair" assumes the first PEM line ends by position 28, but the header
    # "-----BEGIN RSA PRIVATE KEY-----" is 31 characters, so a correctly formatted RSA key
    # supplied as config contents (e.g. an env var) is corrupted. Keys read from a file path
    # are not affected. When fixed, this example will fail as "expected pending to fail":
    # delete the `pending` line.
    it "client_key falls back to RSA contents (BEGIN RSA PRIVATE KEY) in config" do
      pending "cert_contents_with_line_feeds_reinstated corrupts RSA-format PEM headers"
      configure(mesh_client_key: key_pem)

      expect(certificates.client_key).to be_a(OpenSSL::PKey::RSA)
    end

    it "client_key raises if there is neither a file nor config contents" do
      configure

      expect { certificates.client_key }
        .to raise_error(ArgumentError, "Missing config mesh_client_key")
    end

    it "ca_file_path returns the configured path as is when the file already exists" do
      path = File.join(tmp_dir, "ca.pem")
      File.write(path, "existing")
      allow(Renalware.config).to receive_messages(mesh_path_to_nhs_ca_file: path)

      expect(certificates.ca_file_path).to eq(path)
      expect(File.read(path)).to eq("existing")
    end

    it "ca_file_path creates a missing file, and its folders, from the config contents" do
      path = File.join(tmp_dir, "nested/folder/ca.pem")
      allow(Renalware.config).to receive_messages(
        mesh_path_to_nhs_ca_file: path,
        mesh_nhs_ca_cert: cert_pem
      )

      expect(certificates.ca_file_path).to eq(path)
      expect(File.read(path)).to eq(cert_pem)
    end

    it "ca_file_path resolves a relative path against Rails.root" do
      allow(Renalware.config)
        .to receive_messages(mesh_path_to_nhs_ca_file: "spec/support/dummy_mesh_cert.txt")

      expect(certificates.ca_file_path).to eq(cert_path.to_s)
    end

    it "ca_file_path raises if no path is configured" do
      allow(Renalware.config).to receive_messages(mesh_path_to_nhs_ca_file: "")

      expect { certificates.ca_file_path }
        .to raise_error(ArgumentError, "Missing config mesh_path_to_nhs_ca_file")
    end

    it "ca_file_path raises if the file is missing and there is no config to create it from" do
      allow(Renalware.config).to receive_messages(
        mesh_path_to_nhs_ca_file: File.join(tmp_dir, "ca.pem"),
        mesh_nhs_ca_cert: ""
      )

      expect { certificates.ca_file_path }
        .to raise_error(ArgumentError, "Missing config mesh_nhs_ca_cert")
    end
  end
end

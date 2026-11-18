RSpec.describe Relay::GPConnect::Mesh::Certificates do
  let(:cert_path) { File.join(MeshConfigHelper::FIXTURES, "dummy_mesh_cert.txt") }
  let(:key_path) { File.join(MeshConfigHelper::FIXTURES, "dummy_mesh_key.txt") }
  let(:cert_pem) { File.read(cert_path) }
  let(:key_pem) { File.read(key_path) }
  let(:expected_cert_pem) { OpenSSL::X509::Certificate.new(cert_pem).to_pem }
  let(:tmp_dir) { Dir.mktmpdir }

  after { FileUtils.remove_entry(tmp_dir) }

  # A certificates object for a config with no cert/key files or contents unless overridden
  def certificates(**overrides)
    nothing = {
      client_cert_path: nil, client_cert: "", client_key_path: nil, client_key: ""
    }
    described_class.new(config: build_mesh_config(**nothing, **overrides))
  end

  it "client_cert is loaded from the configured file when it exists" do
    client_cert = certificates(client_cert_path: cert_path).client_cert

    expect(client_cert).to be_a(OpenSSL::X509::Certificate)
    expect(client_cert.to_pem).to eq(expected_cert_pem)
  end

  it "client_cert falls back to the cert contents in config when there is no file" do
    client_cert = certificates(client_cert_path: "/no/such/file", client_cert: cert_pem).client_cert

    expect(client_cert.to_pem).to eq(expected_cert_pem)
  end

  it "client_cert reinstates line feeds in a cert pasted into an env var with spaces" do
    client_cert = certificates(client_cert: cert_pem.tr("\n", " ").strip).client_cert

    expect(client_cert.to_pem).to eq(expected_cert_pem)
  end

  it "client_cert raises if there is neither a file nor config contents" do
    expect { certificates.client_cert }
      .to raise_error(ArgumentError, "Missing config mesh_client_cert")
  end

  it "client_key is loaded from the configured file when it exists" do
    expect(certificates(client_key_path: key_path).client_key).to be_a(OpenSSL::PKey::RSA)
  end

  it "client_key falls back to PKCS#8 contents (BEGIN PRIVATE KEY) in config" do
    pkcs8 = OpenSSL::PKey::RSA.new(key_pem).private_to_pem

    expect(certificates(client_key: pkcs8).client_key).to be_a(OpenSSL::PKey::RSA)
  end

  # The header "-----BEGIN RSA PRIVATE KEY-----" is longer than a certificate's, which used to
  # make us wrongly "repair" a good key (and corrupt it).
  it "client_key falls back to RSA contents (BEGIN RSA PRIVATE KEY) in config" do
    client_key = certificates(client_key: key_pem).client_key

    expect(client_key.to_pem).to eq(OpenSSL::PKey::RSA.new(key_pem).to_pem)
  end

  it "client_key reinstates line feeds in an RSA key pasted into an env var with spaces" do
    client_key = certificates(client_key: key_pem.tr("\n", " ").strip).client_key

    expect(client_key.to_pem).to eq(OpenSSL::PKey::RSA.new(key_pem).to_pem)
  end

  it "leaves well formed contents alone even with leading blank lines or Windows line endings" do
    padded = "\n\n#{cert_pem.gsub("\n", "\r\n")}"

    expect(certificates(client_cert: padded).client_cert.to_pem).to eq(expected_cert_pem)
  end

  it "client_key raises if there is neither a file nor config contents" do
    expect { certificates.client_key }
      .to raise_error(ArgumentError, "Missing config mesh_client_key")
  end

  it "ca_file_path returns the configured path as is when the file already exists" do
    path = File.join(tmp_dir, "ca.pem")
    File.write(path, "existing")

    expect(certificates(ca_file_path: path).ca_file_path).to eq(path)
    expect(File.read(path)).to eq("existing")
  end

  it "ca_file_path creates a missing file, and its folders, from the config contents" do
    path = File.join(tmp_dir, "nested/folder/ca.pem")

    expect(certificates(ca_file_path: path, ca_cert: cert_pem).ca_file_path).to eq(path)
    expect(File.read(path)).to eq(cert_pem)
  end

  it "ca_file_path resolves a relative path against base_dir" do
    File.write(File.join(tmp_dir, "ca.pem"), "existing")
    certs = certificates(ca_file_path: "ca.pem", base_dir: Pathname(tmp_dir))

    expect(certs.ca_file_path).to eq(File.join(tmp_dir, "ca.pem"))
  end

  it "ca_file_path raises if no path is configured" do
    expect { certificates(ca_file_path: "").ca_file_path }
      .to raise_error(ArgumentError, "Missing config mesh_path_to_nhs_ca_file")
  end

  it "ca_file_path raises if the file is missing and there is no config to create it from" do
    path = File.join(tmp_dir, "ca.pem")

    expect { certificates(ca_file_path: path, ca_cert: "").ca_file_path }
      .to raise_error(ArgumentError, "Missing config mesh_nhs_ca_cert")
  end
end

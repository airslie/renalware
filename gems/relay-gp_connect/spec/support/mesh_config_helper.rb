module MeshConfigHelper
  FIXTURES = File.expand_path("../fixtures", __dir__)

  # A Mesh::Config with test values; pass overrides for anything that matters to the example.
  def build_mesh_config(**overrides)
    Relay::GPConnect::Mesh::Config.new(**default_mesh_settings, **overrides)
  end

  def default_mesh_settings # rubocop:disable Metrics/MethodLength
    {
      mailbox_id: "RAJ01OT001",
      mailbox_password: "password",
      api_secret: "secret",
      api_base_url: "http://localhost:8700/messageexchange",
      workflow_id: "GPCONNECT_SEND_DOCUMENT",
      client_cert_path: File.join(FIXTURES, "dummy_mesh_cert.txt"),
      client_cert: nil,
      client_key_path: File.join(FIXTURES, "dummy_mesh_key.txt"),
      client_key: nil,
      ca_file_path: File.join(Dir.tmpdir, "relay_gp_connect_spec_ca.pem"),
      ca_cert: File.read(File.join(FIXTURES, "dummy_mesh_cert.txt")),
      base_dir: Pathname(Dir.tmpdir)
    }
  end
end

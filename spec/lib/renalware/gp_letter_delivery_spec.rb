module Renalware
  describe GPLetterDelivery do
    def configure(gp_letter_delivery: nil, send_gp_letters_over_mesh: false)
      allow(Renalware.config).to receive_messages(gp_letter_delivery:, send_gp_letters_over_mesh:)
    end

    it "legacy SEND_GP_LETTERS_OVER_MESH=true (what production uses) is :builtin_mesh" do
      configure(send_gp_letters_over_mesh: true)

      expect(described_class.current).to eq(:builtin_mesh)
      expect(described_class).to be_electronic
      expect(described_class).to be_builtin_mesh
    end

    it "legacy SEND_GP_LETTERS_OVER_MESH=false is :none" do
      configure(send_gp_letters_over_mesh: false)

      expect(described_class.current).to eq(:none)
      expect(described_class).not_to be_electronic
      expect(described_class).not_to be_builtin_mesh
    end

    it "an explicit GP_LETTER_DELIVERY takes precedence over the legacy setting" do
      configure(gp_letter_delivery: "none", send_gp_letters_over_mesh: true)

      expect(described_class.current).to eq(:none)
    end

    it "accepts builtin_mesh as a string or symbol" do
      configure(gp_letter_delivery: "builtin_mesh")
      expect(described_class.current).to eq(:builtin_mesh)

      configure(gp_letter_delivery: :builtin_mesh)
      expect(described_class.current).to eq(:builtin_mesh)
    end

    it "treats a blank GP_LETTER_DELIVERY as not set, falling back to the legacy setting" do
      configure(gp_letter_delivery: "", send_gp_letters_over_mesh: true)

      expect(described_class.current).to eq(:builtin_mesh)
    end

    it "fails loudly for an unknown mode rather than silently not sending" do
      configure(gp_letter_delivery: "carrier_pigeon")

      expect { described_class.current }.to raise_error(ArgumentError, /carrier_pigeon/)
    end

    it "fails loudly for relay until implemented, rather than leaving letters pending" do
      configure(gp_letter_delivery: "relay")

      expect { described_class.current }.to raise_error(NotImplementedError, /relay/i)
    end
  end
end

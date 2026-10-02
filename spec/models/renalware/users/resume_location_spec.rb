module Renalware
  describe Users::ResumeLocation do
    subject(:resume_location) { described_class.new(session) }

    let(:session) { {} }
    let(:user) { build_stubbed(:user) }
    let(:other_user) { build_stubbed(:user) }
    let(:memory) { Renalware.config.duration_of_last_url_memory_after_session_expiry }

    def store(path: "/patients/1", expired_at: Time.current)
      resume_location.store(user:, path:, expired_at:)
    end

    it "returns the stored path to the same user shortly after their session expired" do
      store(path: "/patients/1")

      expect(resume_location.consume_for(user)).to eq("/patients/1")
    end

    it "does not return the path to a different user" do
      store

      expect(resume_location.consume_for(other_user)).to be_nil
    end

    it "does not return the path once the memory period has passed since the session expired" do
      store(expired_at: (memory + 1.minute).ago)

      expect(resume_location.consume_for(user)).to be_nil
    end

    it "returns the path when signing in just within the memory period" do
      store(expired_at: (memory - 1.minute).ago)

      expect(resume_location.consume_for(user)).to eq("/patients/1")
    end

    it "only returns the path once" do
      store

      resume_location.consume_for(user)

      expect(resume_location.consume_for(user)).to be_nil
    end

    it "forgets the path even when another user signs in" do
      store

      resume_location.consume_for(other_user)

      expect(resume_location.consume_for(user)).to be_nil
    end

    it "remembers that there is nowhere to resume when the path is blank" do
      store(path: nil)

      expect(resume_location).to be_stored
      expect(resume_location).not_to be_pending
      expect(resume_location.consume_for(user)).to be_nil
    end

    describe "when the page is not yet known" do
      before { resume_location.store_pending(user:, expired_at: Time.current) }

      it "is pending" do
        expect(resume_location).to be_stored
        expect(resume_location).to be_pending
      end

      it "returns the path it is later resolved to" do
        resume_location.resolve("/patients/1")

        expect(resume_location).not_to be_pending
        expect(resume_location.consume_for(user)).to eq("/patients/1")
      end

      it "returns nothing if it is never resolved" do
        expect(resume_location.consume_for(user)).to be_nil
      end
    end

    it "returns nil when nothing was stored" do
      expect(resume_location.consume_for(user)).to be_nil
    end
  end
end

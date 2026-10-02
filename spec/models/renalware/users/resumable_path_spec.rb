module Renalware
  describe Users::ResumablePath do
    def resumable(path) = described_class.new(path).to_s

    it "keeps a recognised page unchanged, including its query string" do
      expect(resumable("/patients/1/hd/sessions?page=2")).to eq("/patients/1/hd/sessions?page=2")
    end

    it "maps an edit page to the record it was editing" do
      expect(resumable("/patients/1/hd/sessions/5/edit")).to eq("/patients/1/hd/sessions/5")
    end

    it "maps a new page to the parent listing" do
      expect(resumable("/patients/1/hd/sessions/new")).to eq("/patients/1/hd/sessions")
    end

    it "drops the query string when mapping away from a form page" do
      expect(resumable("/patients/1/edit?tab=contact")).to eq("/patients/1")
    end

    it "walks up past unroutable ancestors of a form page to the nearest page" do
      expect(resumable("/patients/1/accesses/assessments/new")).to eq("/patients/1")
    end

    it "skips the page of a singular resource being edited, as it may not have been saved yet" do
      expect(resumable("/patients/1/transplants/donor/workup/edit")).to eq("/patients/1")
      expect(resumable("/patients/1/transplants/recipient/workup/edit")).to eq("/patients/1")
      expect(resumable("/patients/1/transplants/recipient/registration/edit")).to eq("/patients/1")
    end

    it "maps the form of a singular resource nested in a record to that record" do
      expect(resumable("/patients/1/transplants/donor/operations/7/follow_up/edit"))
        .to eq("/patients/1/transplants/donor/operations/7")
    end

    it "resumes pages served by mounted engines" do
      expect(resumable("/research/studies")).to eq("/research/studies")
    end

    it "does not resume an unrecognised path" do
      expect(resumable("/no/such/page")).to be_nil
    end

    it "does not resume authentication pages" do
      expect(resumable("/users/sign_in")).to be_nil
      expect(resumable("/users/password/edit")).to be_nil
    end

    it "does not resume the session keep-alive endpoint" do
      expect(resumable("/keep_session_alive")).to be_nil
    end

    it "does not resume a blank path" do
      expect(resumable(nil)).to be_nil
      expect(resumable("")).to be_nil
    end
  end
end

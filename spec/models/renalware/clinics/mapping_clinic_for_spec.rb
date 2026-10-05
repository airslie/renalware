describe Renalware::Clinics::Mapping, ".clinic_for" do
  let(:clinic1) { create(:clinic) }
  let(:clinic2) { create(:clinic) }
  let(:clinic3) { create(:clinic) }

  before do
    described_class.create!(name_in_feed: "Clinic A", clinic: clinic1, default_clinic: false)
    described_class.create!(name_in_feed: "Clinic B", clinic: clinic2, default_clinic: false)
    described_class.create!(
      name_in_feed: "Default Clinic", clinic: clinic3, default_clinic: true
    )
  end

  it "returns the clinic_id for a matching name" do
    expect(described_class.clinic_for("Clinic A")).to eq(clinic1)
    expect(described_class.clinic_for("Clinic B")).to eq(clinic2)
  end

  it "matches feed names case-insensitively without creating another mapping" do
    expect {
      expect(described_class.clinic_for("CLINIC a")).to eq(clinic1)
    }.not_to change(described_class, :count)
  end

  it "recovers when a competing mapping is detected by validation" do
    hide_initial_match("CLINIC A")

    expect(described_class.clinic_for("CLINIC A")).to eq(clinic1)
    expect(described_class.count).to eq(3)
  end

  it "recovers from a database uniqueness conflict without aborting the transaction" do
    hide_initial_match("CLINIC A")
    allow(described_class).to receive(:create!) do |attributes|
      # Simulate an insert racing after the uniqueness validation has passed.
      described_class.insert_all!([attributes])
    end

    described_class.transaction do
      expect(described_class.clinic_for("CLINIC A")).to eq(clinic1)
      expect(described_class.count).to eq(3)
    end
  end

  it "does not hide unrelated validation errors" do
    expect { described_class.clinic_for("") }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "returns nil for an existing unmapped clinic regardless of case" do
    described_class.create!(name_in_feed: "Unmapped Clinic")

    expect {
      expect(described_class.clinic_for("UNMAPPED CLINIC")).to be_nil
    }.not_to change(described_class, :count)
  end

  it "returns the default clinic_id if no name match" do
    expect(described_class.clinic_for("Non-existent Clinic")).to eq(clinic3)
  end

  it "returns the nil if clinic name is nil" do
    expect(described_class.clinic_for(nil)).to be_nil
  end

  it "returns nil if no match and no default clinic" do
    described_class.where(default_clinic: true).delete_all
    expect(described_class.clinic_for("Non-existent Clinic")).to be_nil
  end

  def hide_initial_match(name)
    matching = described_class.where("lower(name_in_feed) = lower(?)", name)
    allow(described_class).to receive(:where).and_call_original
    allow(described_class).to receive(:where)
      .with("lower(name_in_feed) = lower(?)", name).and_return(matching)
    calls = 0
    allow(matching).to receive(:first).and_wrap_original do |original|
      calls += 1
      calls == 1 ? nil : original.call
    end
  end
end

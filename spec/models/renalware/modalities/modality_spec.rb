# frozen_string_literal: true

module Renalware
  describe Modalities::Modality do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to validate_presence_of :patient
      is_expected.to validate_presence_of :started_on
      is_expected.to validate_presence_of :description_id
      is_expected.to belong_to(:patient).touch(true)
      is_expected.to belong_to(:change_type)
      is_expected.to validate_timeliness_of(:started_on)
      is_expected.to be_versioned
    end

    it "does not implememt policy_class but relies on usual lookup" do
      expect(described_class).not_to respond_to(:policy_class)
    end

    describe "change_type-dependent validation" do
      let(:user) { create(:user) }
      let(:hospital) { create(:hospital_centre, name: "HospA", code: "HospA") }

      context "when the modality has a change_type than requires a source hospital" do
        it "raises a validation error if one is missing" do
          change_type = create(:modality_change_type, require_source_hospital_centre: true)

          modality = build(:modality, change_type: change_type, by: user)

          expect(modality.save).to be(false)
          expect(modality.errors[:source_hospital_centre_id]).to be_present
        end

        it "does not raise an error if one present" do
          change_type = create(:modality_change_type, require_source_hospital_centre: true)

          modality = build(
            :modality,
            change_type: change_type,
            source_hospital_centre: hospital,
            by: user
          )

          expect(modality.save).to be(true)
        end
      end

      context "when the modality has a change_type than requires a destination hospital" do
        it "raises a validation error if one is missing" do
          change_type = create(:modality_change_type, require_destination_hospital_centre: true)

          modality = build(:modality, change_type: change_type, by: user)

          expect(modality.save).to be(false)
          expect(modality.errors[:destination_hospital_centre_id]).to be_present
        end

        it "does not raise an error if one present" do
          change_type = create(:modality_change_type, require_destination_hospital_centre: true)

          modality = build(
            :modality,
            change_type: change_type,
            destination_hospital_centre: hospital,
            by: user
          )

          expect(modality.save).to be(true)
        end
      end
    end

    describe "#change_type_description" do
      let(:user) { create(:user) }
      let(:hospital) { create(:hospital_centre, name: "HospA", code: "HospA") }

      context "when the modality has a no change_type (legacy modalities)" do
        it "returns nil" do
          modality = create(:modality, by: user)
          allow(modality).to receive(:change_type).and_return(nil)

          expect(modality.change_type_description).to be_nil
        end
      end

      context "when the modality has a change_type that requires a source hospital centre" do
        context "when a source hospital centre is present" do
          it "includes the source hospital _s if it has been set" do
            change_type = create(
              :modality_change_type,
              require_source_hospital_centre: true,
              name: "ChangeTypeA",
              by: user
            )
            modality = create(
              :modality,
              change_type: change_type,
              source_hospital_centre: hospital,
              by: user
            )

            expect(modality.change_type_description).to eq("ChangeTypeA from HospA")
          end
        end

        context "when source hospital centre is missing" do
          it "just returns the change_type name" do
            change_type = create(
              :modality_change_type,
              require_source_hospital_centre: true,
              name: "ChangeTypeA",
              by: user
            )
            modality = build(
              :modality,
              change_type: change_type,
              by: user
            )
            # Save w/o validation to prevent the missing source_hospital_centre validation error
            modality.save!(validate: false)

            expect(modality.change_type_description).to eq("ChangeTypeA")
          end
        end

        context "when the modality has a change_type that requires a destination hospital centre" do
          context "when a destination hospital centre is present" do
            it "includes the destination hospital if it has been set" do
              change_type = create(
                :modality_change_type,
                require_destination_hospital_centre: true,
                name: "ChangeTypeA",
                by: user
              )
              modality = create(
                :modality,
                change_type: change_type,
                destination_hospital_centre: hospital,
                by: user
              )

              expect(modality.change_type_description).to eq("ChangeTypeA to HospA")
            end
          end

          context "when destination hospital centre is missing" do
            it "just returns the change_type name" do
              change_type = create(
                :modality_change_type,
                require_destination_hospital_centre: true,
                name: "ChangeTypeA",
                by: user
              )
              modality = build(
                :modality,
                change_type: change_type,
                by: user
              )
              # Save w/o validation to prevent missing destination_hospital_centre validation error
              modality.save!(validate: false)

              expect(modality.change_type_description).to eq("ChangeTypeA")
            end
          end
        end
      end
    end

    describe "validate start date based on previous modalities" do
      before do
        # another_patients_modality
        create(:modality, started_on: Date.parse("2015-06-02"))
      end

      context "when there is no previous modality" do
        subject(:modality) do
          build(:modality, started_on: Date.parse("2015-05-01"))
        end

        it "has a valid start date" do
          modality.valid?
          expect(modality.errors[:started_on]).to be_empty
        end
      end

      context "when there is a previous modality" do
        let!(:patients_modality) { create(:modality, started_on: Date.parse("2015-04-01")) }

        context "when the start date is later than previous start date" do
          subject(:modality) do
            build(
              :modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-05-01")
            )
          end

          it "has a valid start date" do
            modality.valid?
            expect(modality.errors[:started_on]).to be_empty
          end
        end

        context "when the start date is the same as the previous start date" do
          subject(:modality) do
            build(
              :modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-04-01")
            )
          end

          it "has a valid start date" do
            modality.valid?
            expect(modality.errors[:started_on]).to be_empty
          end
        end

        context "when start date is not later than previous start date" do
          subject(:modality) do
            build(
              :modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-03-21")
            )
          end

          it "has an invalid start date" do
            modality.valid?
            expect(modality.errors[:started_on]).to include(/previous modality/)
          end
        end
      end

      it "does not allow a modality start date in the future" do
        modality = build(:modality, patient: nil, started_on: 1.day.from_now.to_date)

        expect(modality).not_to be_valid

        expect(modality.errors[:started_on]).to include("must be on or before #{Date.current}")
      end
    end
  end
end

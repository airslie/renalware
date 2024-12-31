module Renalware
  module HD
    describe SessionPresenter do
      subject(:presenter) { described_class.new(session) }

      let(:session) { instance_double(Session, document: Renalware::HD::SessionDocument.new) }

      it { is_expected.to respond_to(:hospital_unit_unit_code) }

      describe "#summarised_access_used" do
        it "delegates to SessionAccessPresenter" do
          allow_any_instance_of(SessionAccessPresenter).to receive(:to_html)
          presenter.summarised_access_used
        end
      end

      describe "#access_used" do
        it "delegates to SessionAccessPresenter" do
          allow_any_instance_of(SessionAccessPresenter).to receive(:to_s)
          presenter.access_used
        end
      end

      describe "#change_in" do
        context "with float values" do
          it "returns the difference between before and after measurements rounded to 1 DP" do
            session.document.observations_before.weight = 101.1
            session.document.observations_after.weight = 100.0

            expect(presenter.change_in(:weight)).to eq(-1.1)
          end
        end

        context "with integer values" do
          it "returns the difference between before and after measurements" do
            session.document.observations_before.pulse = 70
            session.document.observations_after.pulse = 80

            expect(presenter.change_in(:pulse)).to eq 10
          end
        end

        context "with invalid values" do
          it "returns nil if before or after measurement missing" do
            session.document.observations_before.pulse = 70
            session.document.observations_after.pulse = nil

            expect(presenter.change_in(:pulse)).to be_nil
          end
        end

        context "when values are dodgy" do
          it "returns nil if before measurement is a number but post a string" do
            session.document.observations_before.pulse = 100
            session.document.observations_after.pulse = "100,90"

            expect(presenter.change_in(:pulse)).to be_nil
          end
        end
      end

      describe "#before_measurement_for" do
        it "returns the pre-dialysis measurement" do
          session.document.observations_before.weight = 101.1

          expect(presenter.before_measurement_for(:weight)).to eq 101.1
        end
      end

      describe "#after_measurement_for" do
        it "returns the post-dialysis measurement" do
          session.document.observations_after.weight = 101.1

          expect(presenter.after_measurement_for(:weight)).to eq 101.1
        end
      end

      describe "#access_side_rr40_code" do
        it "maps left to L" do
          session.document.info.access_side = "left"

          expect(presenter.access_side_rr40_code).to eq("L")
        end

        it "maps right to R" do
          session.document.info.access_side = "right"

          expect(presenter.access_side_rr40_code).to eq("R")
        end

        it "maps anything else (ie unknown) to U" do
          [nil, "", "xyz"].each do |side|
            session.document.info.access_side = side

            expect(presenter.access_side_rr40_code).to eq("U")
          end
        end
      end

      describe "#access_rr02_code" do
        subject { presenter.access_rr02_code }
        # We store in the session only the access abbreviation of rr02 + rr41
        # To resolve rr02 we assume it is the first word in the abbreviation.

        context "when access_abbreviation is two words" do
          before { session.document.info.access_type_abbreviation = "rr02 rr41" }

          it { is_expected.to eq("rr02") }
        end

        context "when access_abbreviation is one word ie just the rr02 code" do
          before { session.document.info.access_type_abbreviation = "rr02" }

          it { is_expected.to eq("rr02") }
        end

        context "when access_abbreviation is nil" do
          before { session.document.info.access_type_abbreviation = nil }

          it { is_expected.to be_nil }
        end

        context "when access_abbreviation is an empty string" do
          before { session.document.info.access_type_abbreviation = "" }

          it { is_expected.to be_nil }
        end
      end

      describe "#access_rr41_code" do
        subject { presenter.access_rr41_code }
        # We store in the session only the access abbreviation of rr02 + rr41
        # To resolve rr02 we assume it is the last word in the abbreviation if there are >1 words.

        context "when access_abbreviation is two words" do
          before { session.document.info.access_type_abbreviation = "rr02 rr41" }

          it { is_expected.to eq("rr41") }
        end

        context "when access_abbreviation is one word ie just the rr02 code" do
          before { session.document.info.access_type_abbreviation = "rr02" }

          it { is_expected.to be_nil }
        end

        context "when access_abbreviation is nil" do
          before { session.document.info.access_type_abbreviation = nil }

          it { is_expected.to be_nil }
        end

        context "when access_abbreviation is an empty string" do
          before { session.document.info.access_type_abbreviation = "" }

          it { is_expected.to be_nil }
        end
      end
    end
  end
end

module Renalware
  describe UKRDC::PatientsQuery do
    let(:patient) { build(:patient, by: user) }
    let(:user) { create(:user) }

    describe ".call" do
      context "when the changed_since_last_send boolean argument is false" do
        it "returns the entire PKB and RR population even if not changed since last send" do
          patient1 = create(
            :patient,
            family_name: "Jones",
            updated_at: 1.year.ago,
            sent_to_ukrdc_at: 1.minute.ago,
            send_to_rpv: true
          )
          patient2 = create(
            :patient,
            family_name: "Smith",
            updated_at: 1.year.ago,
            sent_to_ukrdc_at: 1.minute.ago,
            send_to_renalreg: true
          )
          create(
            :patient,
            family_name: "Smith",
            updated_at: 1.year.ago,
            sent_to_ukrdc_at: 1.minute.ago,
            send_to_renalreg: false,
            send_to_rpv: false
          )
          create(:patient, send_to_rpv: false, send_to_renalreg: false)

          expect(
            described_class.new.call(changed_since_last_send: false)
          ).to eq([patient1, patient2])
        end
      end

      context "when the optional :changed_since argument is not specified" do
        subject(:query_results) { described_class.new.call }

        context "when there no patients with send_to_rpv or send_to_renalreg set" do
          it { is_expected.to be_empty }
        end

        context "when a patient has the PKB (previously RPV) flag" do
          before { patient.update(send_to_rpv: true, send_to_renalreg: false) }

          context "when they have never been sent to ukrdc" do
            before { patient.update(sent_to_ukrdc_at: nil, by: user) }

            it { is_expected.to eq([patient]) }
          end

          context "when they would otherwise be sent but config.ukrdc_skip_rpv_patients is true" do
            before { patient.update(sent_to_ukrdc_at: nil, by: user) }

            it "does not send them" do
              allow(Renalware.config).to receive(:ukrdc_send_rpv_patients).and_return(false)

              expect(query_results).to be_empty
            end
          end

          context "when they also have changed since the last export date" do
            before { patient.update(sent_to_ukrdc_at: 1.day.ago, updated_at: 1.hour.ago, by: user) }

            it { is_expected.to eq([patient]) }
          end

          context "when they haven't changed since the last export date" do
            before { patient.update(sent_to_ukrdc_at: 1.day.ago, updated_at: 2.days.ago, by: user) }

            it { is_expected.to be_empty }
          end
        end

        context "when a patient has the RenalReg flag" do
          before {
            patient.update(send_to_renalreg: true, send_to_rpv: false)
          }

          context "when they have never been sent to ukrdc" do
            before { patient.update(sent_to_ukrdc_at: nil, by: user) }

            it { is_expected.to eq([patient]) }
          end

          context "when they would otherwise be sent but config.ukrdc_skip_rreg_patients is true" do
            before { patient.update(sent_to_ukrdc_at: nil, by: user) }

            it "does not send them" do
              allow(Renalware.config).to receive(:ukrdc_send_rreg_patients).and_return(false)

              is_expected.to be_empty
            end
          end

          context "when they also have changed since the last export date" do
            before { patient.update(sent_to_ukrdc_at: 1.day.ago, updated_at: 1.hour.ago, by: user) }

            it { is_expected.to eq([patient]) }
          end

          context "when they haven't changed since the last export date" do
            before { patient.update(sent_to_ukrdc_at: 1.day.ago, updated_at: 2.days.ago, by: user) }

            it { is_expected.to be_empty }
          end
        end

        describe "patient recently opted out of PKB (previously RPV)" do
          context "when a patient does not have the PKB (previously RPV) flag" do
            before { patient.update(send_to_rpv: false) }

            context "when their updated_at has changed since the last export" do
              before do
                patient.update(sent_to_ukrdc_at: 1.day.ago, updated_at: 1.hour.ago, by: user)
              end

              it { is_expected.to be_empty }
            end
          end
        end

        describe "patient recently opted out of Renal Reg" do
          context "when a patient does not have the RR flag" do
            before { patient.update(send_to_renalreg: false, send_to_rpv: false) }

            context "when their updated_at has changed since the last export" do
              before do
                patient.update(sent_to_ukrdc_at: 1.day.ago, updated_at: 1.hour.ago, by: user)
              end

              it { is_expected.to be_empty }
            end
          end
        end
      end

      context "when :changed_since argument is specified" do
        subject { described_class.new.call(changed_since: 1.week.ago) }

        context "when there no patients with send_to_rpv set" do
          it { is_expected.to be_empty }
        end

        context "when a patient has the PKB (previously RPV) flag" do
          before { patient.update(send_to_rpv: true) }

          context "when they have changed since the :changed_since date" do
            before { patient.update(sent_to_ukrdc_at: nil, updated_at: 4.days.ago, by: user) }

            it { is_expected.to eq([patient]) }
          end

          context "when they haven't changed since the :changed_since date" do
            before { patient.update(sent_to_ukrdc_at: nil, updated_at: 3.weeks.ago, by: user) }

            it { is_expected.to be_empty }
          end
        end

        context "when a patient has the RenalReg flag" do
          before { patient.update(send_to_rpv: false, send_to_renalreg: true) }

          context "when they have changed since the :changed_since date" do
            before { patient.update(sent_to_ukrdc_at: nil, updated_at: 4.days.ago, by: user) }

            it { is_expected.to eq([patient]) }
          end

          context "when they haven't changed since the :changed_since date" do
            before { patient.update(sent_to_ukrdc_at: nil, updated_at: 3.weeks.ago, by: user) }

            it { is_expected.to be_empty }
          end
        end
      end
    end
  end
end

module Renalware
  module Transplants
    module Registrations
      describe WaitListQuery do
        describe "#call" do
          subject(:query) { described_class.new(named_filter: filter) }

          before do
            %w(active suspended working_up working_up_lrf).each do |status|
              create(:transplant_registration, :in_status, status:)
            end
          end

          context "with filter 'all'" do
            let(:filter) { :all }

            it "returns all registrations" do
              expect(query.call.count).to eq(4)
            end
          end

          context "with filter 'active'" do
            let(:filter) { :active }

            it "returns the active registrations" do
              expect(query.call.count).to eq(1)
            end
          end

          context "with filter 'suspended'" do
            let(:filter) { :suspended }

            it "returns the suspended registrations" do
              expect(query.call.count).to eq(1)
            end
          end

          context "with filter 'active_and_suspended'" do
            let(:filter) { :active_and_suspended }

            it "returns the active and suspended registrations" do
              expect(query.call.count).to eq(2)
            end
          end

          context "with filter 'working_up'" do
            let(:filter) { :working_up }

            it "returns the working-up registrations" do
              expect(query.call.count).to eq(2)
            end
          end

          context "when an explicit sort is supplied" do
            let(:filter) { :all }

            it "respects the requested sort instead of resetting to patient name" do
              later = create(:transplant_registration, entered_on: Date.parse("2024-02-01"))
              earlier = create(:transplant_registration, entered_on: Date.parse("2024-01-01"))

              query = described_class.new(
                named_filter: filter,
                q: ActionController::Parameters.new(s: "entered_on asc")
              )

              ids = query.call.pluck(:id)

              expect(ids.index(earlier.id)).to be < ids.index(later.id)
            end

            it "sorts by esrf_on" do
              later = create(:transplant_registration)
              create(
                :renal_profile,
                patient_id: later.patient.id,
                first_seen_on: "01-01-2017",
                esrf_on: Date.parse("2024-02-01")
              )

              earlier = create(:transplant_registration)
              create(
                :renal_profile,
                patient_id: earlier.patient.id,
                first_seen_on: "01-01-2017",
                esrf_on: Date.parse("2024-01-01")
              )

              query = described_class.new(
                named_filter: filter,
                q: ActionController::Parameters.new(s: "esrf_on asc")
              )

              ids = query.call.pluck(:id)

              expect(ids.index(earlier.id)).to be < ids.index(later.id)
            end

            it "sorts by hd_site" do
              z_site = create(:hd_hospital_unit, unit_code: "ZZZ")
              z_registration = create(:transplant_registration)
              create(:hd_profile, patient_id: z_registration.patient.id, hospital_unit: z_site)

              a_site = create(:hd_hospital_unit, unit_code: "AAA")
              a_registration = create(:transplant_registration)
              create(:hd_profile, patient_id: a_registration.patient.id, hospital_unit: a_site)

              query = described_class.new(
                named_filter: filter,
                q: ActionController::Parameters.new(s: "hd_site asc")
              )

              ids = query.call.pluck(:id)

              expect(ids.index(a_registration.id)).to be < ids.index(z_registration.id)
            end

            it "sorts by patient_current_status_description_name" do
              suspended = create(:transplant_registration, :in_status, status: "suspended")
              active = create(:transplant_registration, :in_status, status: "active")

              query = described_class.new(
                named_filter: filter,
                q: ActionController::Parameters.new(
                  s: "patient_current_status_description_name asc"
                )
              )

              ids = query.call.pluck(:id)

              expect(ids.index(active.id)).to be < ids.index(suspended.id)
            end

            it "sorts by ukt_status" do
              z_registration = create_registration(status: "active", ukt_status: "Z")
              a_registration = create_registration(status: "active", ukt_status: "A")

              query = described_class.new(
                named_filter: filter,
                q: ActionController::Parameters.new(s: "ukt_status asc")
              )

              ids = query.call.pluck(:id)

              expect(ids.index(a_registration.id)).to be < ids.index(z_registration.id)
            end
          end

          context "with filter 'status_mismatch'" do
            subject(:query) { described_class.new(named_filter: :status_mismatch) }

            context "when the patient is active and UKT status contains A" do
              it "does not choose the registration" do
                create_registration(status: "active", ukt_status: "A")

                expect(query.call.map(&:id)).to eq([])
              end
            end

            context "when the patient is suspended and UKT status contains A" do
              it "chooses the registration" do
                registration = create_registration(status: "suspended", ukt_status: "A")

                expect(query.call.map(&:id)).to eq([registration.id])
              end
            end

            context "when the patient is active but UKT status is something else" do
              it "chooses the registration" do
                registration = create_registration(status: "active", ukt_status: "O")

                expect(query.call.map(&:id)).to eq([registration.id])
              end
            end

            context "when the patient is active but UKT status is an empty string" do
              it "chooses the registration" do
                registration = create_registration(status: "active", ukt_status: "")

                expect(query.call.map(&:id)).to eq([registration.id])
              end
            end

            context "when the patient is active but UKT status is a null" do
              it "find chooses patient" do
                registration = create_registration(status: "active", ukt_status: nil)
                pending "Need to look into why a query does not catch those with a nil ukt status"

                expect(query.call.map(&:id)).to eq([registration.id])
              end
            end

            context "when the patient is neither active or suspended but UKT status is active" do
              it "chooses the registration" do
                registration = create_registration(status: "transplanted", ukt_status: "A")

                expect(query.call.map(&:id)).to eq([registration.id])
              end
            end
          end

          def create_registration(status:, ukt_status:)
            registration = create(:transplant_registration, :in_status, status:)
            registration.document.uk_transplant_centre.status = ukt_status
            registration.save!
            registration
          end
        end
      end
    end
  end
end

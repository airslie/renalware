module Renalware
  module Transplants
    module Registrations
      describe WaitListQuery do
        describe "#call" do
          subject(:query) { described_class.new(named_filter: filter) }

          before do
            %w(active suspended working_up working_up_lrf).each do |status|
              create(:transplant_registration, :in_status, status: status)
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
        end

        def create_registration(status:, ukt_status:)
          registration = create(:transplant_registration, :in_status, status: status)
          registration.document.uk_transplant_centre.status = ukt_status
          registration.save!
          registration
        end
      end
    end
  end
end

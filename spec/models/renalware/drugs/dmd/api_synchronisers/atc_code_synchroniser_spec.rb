# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    describe APISynchronisers::AtcCodeSynchroniser do
      describe "#call" do
        let(:instance) {
          described_class.new(atc_vmp_mapping_repository: atc_vmp_mapping_repository)
        }

        let(:atc_vmp_mapping_repository) do
          instance_double \
            Repositories::AtcVMPMappingRepository,
            call: []
        end

        context "with an entry" do
          let(:entry) do
            instance_double \
              Repositories::AtcVMPMappingRepository::Entry,
              atc_code: "atc_code",
              vmp_code: "code"
          end

          before do
            allow(atc_vmp_mapping_repository).to receive(:call)
              .and_return([entry])
          end

          context "when vmp with a matching code doesn't exist" do
            it "does nothing" do
              instance.call

              expect(VirtualMedicalProduct.count).to eq 0
            end
          end

          context "when entry with a matching code exists" do
            it "updates the atc_code" do
              create(:dmd_virtual_medical_product, code: "code")

              instance.call

              expect(VirtualMedicalProduct.count).to eq 1

              vmp = VirtualMedicalProduct.first
              expect(vmp.atc_code).to eq "atc_code"
              expect(vmp.code).to eq "code"
            end
          end
        end
      end
    end
  end
end

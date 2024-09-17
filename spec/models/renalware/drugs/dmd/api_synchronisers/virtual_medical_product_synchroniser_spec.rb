# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    describe APISynchronisers::VirtualMedicalProductSynchroniser do
      describe "#call" do
        let(:instance) {
          described_class.new(repository: vmp_repository)
        }

        let(:vmp_repository) {
          instance_double(Repositories::VirtualMedicalProductRepository, call: [])
        }

        context "with no entries" do
          it "does nothing" do
            instance.call

            expect(VirtualMedicalProduct.count).to eq 0
          end
        end

        context "with an entry" do
          let(:entry) do
            Repositories::VirtualMedicalProductRepository::Entry.new(
              code: "code",
              name: "name",
              form_code: "form_code",
              route_code: "route_code",
              active_ingredient_strength_numerator_uom_code: "unit_of_measure_code",
              basis_of_strength: "basis_of_strength",
              strength_numerator_value: "strength_numerator_value",
              virtual_therapeutic_moiety_code: "1234",
              inactive: false
            )
          end

          before do
            allow(vmp_repository).to receive(:call)
              .and_return([entry], [])
          end

          context "when entry with same code doesn't exist" do
            it "inserts it" do
              instance.call

              expect(VirtualMedicalProduct.count).to eq 1

              item = VirtualMedicalProduct.first
              expect(item).to have_attributes(
                code: "code",
                name: "name",
                form_code: "form_code",
                route_code: "route_code",
                active_ingredient_strength_numerator_uom_code: "unit_of_measure_code",
                basis_of_strength: "basis_of_strength",
                strength_numerator_value: "strength_numerator_value",
                virtual_therapeutic_moiety_code: "1234"
              )
            end
          end

          context "when entry with same code exists" do
            it "updates it" do
              create(:dmd_virtual_medical_product,
                     code: "code",
                     name: "Some other name")

              expect(VirtualMedicalProduct.find_by(code: "code").name).to eq "Some other name"

              instance.call

              expect(VirtualMedicalProduct.count).to eq 1

              item = VirtualMedicalProduct.first
              expect(item).to have_attributes(
                code: "code",
                name: "name",
                form_code: "form_code",
                route_code: "route_code",
                active_ingredient_strength_numerator_uom_code: "unit_of_measure_code",
                basis_of_strength: "basis_of_strength",
                strength_numerator_value: "strength_numerator_value",
                virtual_therapeutic_moiety_code: "1234"
              )
            end
          end
        end
      end
    end
  end
end

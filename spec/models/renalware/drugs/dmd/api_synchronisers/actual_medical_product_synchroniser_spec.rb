module Renalware
  module Drugs::DMD
    describe APISynchronisers::ActualMedicalProductSynchroniser do
      describe "#call" do
        let(:instance) {
          described_class.new(actual_medical_product_repository: actual_medical_product_repository)
        }

        let(:actual_medical_product_repository) {
          instance_double(Repositories::ActualMedicalProductRepository, call: [])
        }

        context "with no entries" do
          it "does nothing" do
            instance.call

            expect(ActualMedicalProduct.count).to eq 0
          end
        end

        context "with an entry" do
          let(:virtual_medical_product_code) { "1234" }

          let(:entry) do
            instance_double(
              Repositories::ActualMedicalProductRepository::Entry,
              code: "code",
              name: "name",
              virtual_medical_product_code: virtual_medical_product_code
            )
          end

          before do
            allow(actual_medical_product_repository).to receive(:call)
              .and_return([entry], [])
          end

          context "when entry with same code doesn't exist" do
            it "inserts it" do
              instance.call

              expect(ActualMedicalProduct.count).to eq 1

              item = ActualMedicalProduct.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
              expect(item.virtual_medical_product_code).to eq "1234"
            end
          end

          context "when entry doesn't have a virtual medical product code" do
            let(:virtual_medical_product_code) { nil }

            it "skips inserting it (as not use currently)" do
              instance.call

              expect(ActualMedicalProduct.count).to eq 0
            end
          end

          context "when entry with same code exists" do
            it "updates it" do
              create(:dmd_actual_medical_product,
                     code: "code",
                     name: "Some other name")

              expect(ActualMedicalProduct.find_by(code: "code").name).to eq "Some other name"

              instance.call

              expect(ActualMedicalProduct.count).to eq 1

              item = ActualMedicalProduct.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
              expect(item.virtual_medical_product_code).to eq "1234"
            end
          end
        end
      end
    end
  end
end

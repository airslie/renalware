module Renalware
  module Drugs
    describe DMD::APISynchronisers::FormSynchroniser do
      describe "#call" do
        let(:instance) {
          described_class.new(form_repository: form_repository)
        }

        let(:form_repository) {
          instance_double(DMD::Repositories::FormRepository, call: [])
        }

        context "with no entries" do
          it "does nothing" do
            instance.call

            expect(Form.count).to eq 0
          end
        end

        context "with an entry" do
          let(:entry) do
            instance_double(
              DMD::Repositories::FormRepository::Entry,
              code: "code",
              name: "name"
            )
          end

          before do
            allow(form_repository).to receive(:call)
              .and_return([entry], [])
          end

          context "when entry with same code doesn't exist" do
            it "inserts it" do
              instance.call

              expect(Form.count).to eq 1

              item = Form.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
            end
          end

          context "when entry with same code exists" do
            it "updates it" do
              create(:drug_form,
                     code: "code",
                     name: "Some other name")

              expect(Form.find_by(code: "code").name).to eq "Some other name"

              instance.call

              expect(Form.count).to eq 1

              item = Form.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
            end
          end
        end
      end
    end
  end
end

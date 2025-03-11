module Renalware
  module Letters
    describe Letter do
      it_behaves_like "a Paranoid model"

      it :aggregate_failures do
        is_expected.to validate_presence_of(:letterhead)
        is_expected.to validate_presence_of(:patient)
        is_expected.to validate_presence_of(:author)
        is_expected.to validate_presence_of(:main_recipient)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to have_many(:electronic_receipts).dependent(:destroy)
        is_expected.to respond_to(:pathology_timestamp)
        is_expected.to respond_to(:pathology_snapshot)
        is_expected.to have_many(:qr_encoded_online_reference_links)
        is_expected
          .to have_many(:online_reference_links)
          .through(:qr_encoded_online_reference_links)
        is_expected.to have_db_index(:deleted_at)
      end

      describe "validate_presence_of(topic)" do
        context "when description hasn't been set" do
          it do
            is_expected.to validate_presence_of(:topic)
          end
        end

        context "when description has been set" do
          it "does not validate presence of topic" do
            letter = described_class.new(description: "test")
            letter.valid?
            expect(letter.errors.include?(:topic)).to be false
          end
        end
      end

      describe ".printable_gp_send_statues" do
        it "returns the statuses that are printable, ie excluding pending" do
          expect(described_class.printable_gp_send_statues)
            .to eq(%w(not_applicable success failure))
        end
      end

      describe "#include_pathology_in_letter_body?" do
        subject { described_class.new(letterhead: letterhead).include_pathology_in_letter_body? }

        let(:letterhead) do
          build_stubbed(:letter_letterhead, include_pathology_in_letter_body: true)
        end

        it { is_expected.to be(true) }
      end

      describe "self.effective_date_sort" do
        it "generates a SQL coalesce statement to return the most relevant date for the letter" do
          expect(
            described_class.effective_date_sort
          ).to eq(
            "coalesce( completed_at, approved_at, submitted_for_approval_at, " \
            "letter_letters.created_at )"
          )
        end
      end

      describe "#external_id" do
        it "pads the letter id with zeros and prefixes RW" do
          letter = described_class.new(id: 123)

          expect(letter.external_id).to eq("RW0000000123")
        end
      end

      describe "#external_document_type" do
        {
          true => {
            code: "CL",
            name: "Clinic Letter"
          },
          false => {
            code: "AL",
            name: "Adhoc Letter"
          }
        }.each do |clinical_bool, doctype_hash|
          it "is #{doctype_hash[:code]}, #{doctype_hash[:name]} if clinical is #{clinical_bool}" do
            letter = described_class.new(clinical: clinical_bool)

            expect(letter.external_document_type_code).to eq(doctype_hash[:code])
            expect(letter.external_document_type_description).to eq(doctype_hash[:name])
          end
        end
      end

      describe "#date" do
        context "when #approved_at is present" do
          it "returns #approved_at" do
            expect(
              described_class.new(
                created_at: "20-12-2020",
                approved_at: "21-12-2020"
              ).date
            ).to eq(Date.parse("21-12-2020"))
          end
        end

        context "when #approved_at is missing" do
          it "returns #submitted_for_approval_at" do
            expect(
              described_class.new(
                approved_at: nil,
                submitted_for_approval_at: "20-12-2020",
                created_at: "20-11-2020"
              ).date
            ).to eq(Date.parse("20-12-2020"))
          end
        end

        context "when #approved_at and submitted_for_approval_at are missing" do
          it "returns #created_at" do
            expect(
              described_class.new(
                approved_at: nil,
                submitted_for_approval_at: nil,
                created_at: "20-11-2020"
              ).date
            ).to eq(Date.parse("20-11-2020"))
          end
        end
      end

      describe "#gp_is_a_recipient?" do
        context "when gp is among the recipients" do
          it "returns true" do
            letter = described_class.new
            recipient = Letters::Recipient.new
            allow(recipient).to receive(:primary_care_physician?).and_return(true)
            allow(letter).to receive(:recipients).and_return([recipient])

            expect(letter.gp_is_a_recipient?).to be(true)
          end
        end

        context "when gp is not among the recipients" do
          it "returns false" do
            letter = described_class.new
            recipient = Letters::Recipient.new
            allow(recipient).to receive(:primary_care_physician?).and_return(false)
            allow(letter).to receive(:recipients).and_return([recipient])

            expect(letter.gp_is_a_recipient?).to be(false)
          end
        end
      end
    end
  end
end

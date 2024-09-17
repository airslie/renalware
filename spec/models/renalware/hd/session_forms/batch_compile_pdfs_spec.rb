# frozen_string_literal: true

require "pdf/reader"

module Renalware
  module HD
    describe SessionForms::BatchCompilePdfs do
      let(:user) { create(:user) }

      def create_batch
        batch = SessionForms::Batch.create!(by: create(:user))
        batch.items.create(printable_id: create(:hd_patient, given_name: "SMITH").id)
        batch.items.create(printable_id: create(:hd_patient, given_name: "JONES").id)
        batch
      end

      describe "#call" do
        it "compiles an HD session form PDF (aka protocol) for each batch item (patient)" do
          batch = create_batch
          Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
            Dir.chdir(dir) do
              described_class.call(batch, user)
            end
          end
          expect(batch.filepath).to be_present
          # expect PDF to have 2 pages
          expect(PDF::Reader.new(batch.filepath).page_count).to eq(2)
        end
      end
    end
  end
end

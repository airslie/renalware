# frozen_string_literal: true

module Renalware
  module UKRDC::TreatmentTimeline
    describe RemapModelTableNamesToTheirPreparedEquivalents do
      let(:connection) { ActiveRecord::Base.connection }
      let(:patient) { create(:hd_patient) }
      let(:user) { create(:user) }
      let(:klass) { Renalware::HD::Profile }

      def create_an_hd_profile
        create(:hd_profile, patient: patient, by: user)
      end

      it "only allows certain processes to use it" do
        stub_const("Renalware::UKRDC::TreatmentTimeline::" \
                   "RemapModelTableNamesToTheirPreparedEquivalents::ALLOWED_PROCESSES", [])
        expect {
          described_class.new.call
        }.to raise_error(RemapModelTableNamesToTheirPreparedEquivalents::ExecutionNotAllowedError)
      end

      context "when a prepared equivalent does not exist" do
        it "leaves the table_name of the class unchanged" do
          create_an_hd_profile
          table_name_before = klass.table_name

          described_class.new.call(klass) do
            expect(klass.table_name).to eq(table_name_before)
            expect(klass.count).to eq(1)
          end

          expect(klass.table_name).to eq(table_name_before)
          expect(klass.count).to eq(1)
        end
      end

      context "when a prepared equivalent exists" do
        it "changes the underlying class_name for the duration of the block" do
          create_an_hd_profile
          table_name_before = Renalware::HD::Profile.table_name
          table_name_after = "ukrdc_prepared_hd_profiles"
          # Create the prepared table with 0 rows, so we will know if we have the right table
          connection.execute(<<-SQL.squish)
            drop table if exists #{table_name_after};
            select * into #{table_name_after} from hd_profiles limit 0;
          SQL

          described_class.new.call(klass) do
            expect(klass.table_name).to eq(table_name_after)
            expect(klass.count).to eq(0) # prooves we are looking at the right table
          end

          expect(klass.table_name).to eq(table_name_before)
          expect(klass.count).to eq(1)
        end
      end
    end
  end
end

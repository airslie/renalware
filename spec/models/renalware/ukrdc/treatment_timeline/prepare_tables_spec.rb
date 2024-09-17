# frozen_string_literal: true

module Renalware
  module UKRDC
    describe TreatmentTimeline::PrepareTables do
      let(:connection) { ActiveRecord::Base.connection }

      describe ".call" do
        context "when the ukrdc_prepare_tables function does not exist" do
          it "returns false" do
            expect(described_class.call).to be_falsey
          end
        end

        context "when the ukrdc_prepare_tables function exists, letting a site prepare various " \
                "tables and save them as eg ukrdc_prepared_hd_profiles" do
          it "calls the SQL function" do
            # We can assert this by making a test SQL function raise an exception
            connection.execute(<<-SQL.squish)
              create function renalware.ukrdc_prepare_tables() RETURNS void
              LANGUAGE plpgsql AS $$
              BEGIN
              RAISE EXCEPTION 'this will blow up';
              END; $$;
            SQL

            expect {
              described_class.call
            }.to raise_error ActiveRecord::StatementInvalid
          end

          it "returns true" do
            connection.execute(
              "create function renalware.ukrdc_prepare_tables() RETURNS void " \
              "LANGUAGE plpgsql AS $$ BEGIN END; $$;"
            )

            expect(described_class.call).to be_truthy
          end
        end
      end
    end
  end
end

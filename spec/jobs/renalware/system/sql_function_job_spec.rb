# frozen_string_literal: true

describe Renalware::System::SqlFunctionJob do
  it "raises an error if the sql fn does not exist" do
    expect {
      described_class.perform_now("test_sql_fn")
    }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "raise an error if the SQL fn does not return an array int[] with 2 values" do
    ActiveRecord::Base.connection.execute(<<-SQL.squish)
      CREATE FUNCTION renalware.test_fn(out random_name integer)
        LANGUAGE plpgsql AS $$
      BEGIN
        select into random_name 123;
      END $$;
    SQL

    expect {
      described_class.perform_now("renalware.test_fn()")
    }.to raise_error(Renalware::System::SqlFunctionJob::InvalidSqlFunctionDefinitionError)
  end

  context "when target function is defined correctly" do
    it "job executes the SQL fn and creates an APILog entry storing the resulting out parameters" do
      ActiveRecord::Base.connection.execute(<<-SQL.squish)
        CREATE FUNCTION renalware.test_fn(out records_added integer, out records_updated integer)
          LANGUAGE plpgsql AS $$
        BEGIN
          select into records_added, records_updated 123, 456;
        END $$;
      SQL

      expect {
        described_class.perform_now("renalware.test_fn()")
      }.to change(Renalware::System::APILog, :count).by(1)

      expect(Renalware::System::APILog.last).to have_attributes(
        records_added: 123,
        records_updated: 456,
        identifier: "renalware.test_fn()"
      )
    end

    it "job stores the error in APILog if the SQL fn has an exception" do
      ActiveRecord::Base.connection.execute(<<-SQL.squish)
        CREATE FUNCTION renalware.test_fn(out records_added integer, out records_updated integer)
          LANGUAGE plpgsql AS $$
        BEGIN
          /* (456/0) causes division by zero */
          select into records_added, records_updated 123, (456/0);
        END $$;
      SQL

      expect {
        described_class.perform_now("renalware.test_fn()")
      }.to raise_error(ActiveRecord::StatementInvalid, /PG::DivisionByZero/)

      expect(Renalware::System::APILog.last).to have_attributes(
        records_added: 0,
        records_updated: 0,
        identifier: "renalware.test_fn()",
        error: /PG::DivisionByZero/
      )
    end
  end
end

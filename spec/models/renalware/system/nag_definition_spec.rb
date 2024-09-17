# frozen_string_literal: true

describe Renalware::System::NagDefinition do
  it :aggregate_failures do
    is_expected.to validate_presence_of :description
    is_expected.to validate_presence_of :sql_function_name
    is_expected.to validate_presence_of :importance
  end

  describe "uniqueness" do
    subject do
      described_class.new(
        description: "x",
        sql_function_name: "x",
        importance: 1,
        title: "x",
        scope: :patient
      )
    end

    it { is_expected.to validate_uniqueness_of :description }
  end
end

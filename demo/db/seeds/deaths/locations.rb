module Renalware
  Rails.benchmark "Death locations" do
    [
      ["Home", 11],
      ["Nursing Home", 12],
      ["Hospice", 13],
      ["Hospital", 14],
      ["Other", 14]
    ].each do |opts|
      Deaths::Location.find_or_create_by!(name: opts[0]) do |dl|
        dl.ukrdc_assessment_outcome_code = opts[1]
      end
    end
  end
end

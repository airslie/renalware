module Renalware
  Rails.benchmark "Death locations" do
    [
      ["Home", 11, "Current Home"],
      ["Nursing Home", 12, "Nursing Home"],
      ["Hospice", 13, "Hospice"],
      ["Hospital", 14, "Hospital"],
      ["Other", 14, "Other"]
    ].each do |opts|
      Deaths::Location.find_or_create_by!(name: opts[0]) do |dl|
        dl.rr_outcome_code = opts[1]
        dl.rr_outcome_text = opts[2]
      end
    end
  end
end

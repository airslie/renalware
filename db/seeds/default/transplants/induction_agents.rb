require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Transplant Induction Agents" do
    [
      "IL-2",
      "ATG",
      "Campath",
      "ABOi desensitisation"
    ].each_with_index do |name, index|
      Transplants::InductionAgent.find_or_create_by!(name: name) { |ia| ia.position = index }
    end
  end
end

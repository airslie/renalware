# frozen_string_literal: true

require_relative "../../seeds_helper"

module Renalware
  extend SeedsHelper

  # log "Adding Medication Routes" do
  #   module RR
  #     ORAL = 1
  #     TOPICAL = 2
  #     INHALATION = 3
  #     INJECTION = 4
  #     INTRAPERITONEAL = 5
  #     OTHER = 9
  #   end

  #   MRoute = Medications::MedicationRoute
  #   MRoute.transaction do
  #     MRoute.find_or_create_by!(code: "PO", name: "Per Oral", rr_code: RR::ORAL)
  #     MRoute.find_or_create_by!(code: "IV", name: "Intravenous", rr_code: RR::INJECTION)
  #     MRoute.find_or_create_by!(code: "SC", name: "Subcutaneous", rr_code: RR::INJECTION)
  #     MRoute.find_or_create_by!(code: "IM", name: "Intramuscular", rr_code: RR::INJECTION)
  #     MRoute.find_or_create_by!(code: "IP", name: "Intraperitoneal", rr_code: RR::INTRAPERITONEAL)
  #     MRoute.find_or_create_by!(code: "INH", name: "Inhaler", rr_code: RR::INHALATION)
  #     MRoute.find_or_create_by!(code: "SL", name: "Sublingual", rr_code: RR::OTHER)
  #     MRoute.find_or_create_by!(code: "NG", name: "Nasogastric", rr_code: RR::OTHER)
  #     MRoute.find_or_create_by!(code: "PARENT", name: "Parenteral", rr_code: RR::INJECTION)
  #     MRoute.find_or_create_by!(code: "PERCUT", name: "Percutaneous", rr_code: RR::OTHER)
  #     MRoute.find_or_create_by!(code: "TOP", name: "Topical", rr_code: RR::TOPICAL)
  #     MRoute.find_or_create_by!(code: "OTHER", name: "Other", rr_code: RR::OTHER)
  #     MRoute.find_or_create_by!(code: "PR", name: "PerRectum", rr_code: RR::OTHER)
  #   end
  # end
end

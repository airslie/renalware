# frozen_string_literal: true

require_relative "../../seeds_helper"

module Renalware
  module Virology
    extend SeedsHelper

    log "Adding virology vaccination types" do
      {
        hbv1: { name: "HBV Vaccination 1", atc_codes: ["J07BC%"] },
        hbv2: { name: "HBV Vaccination 2", atc_codes: ["J07BC%"] },
        hbv3: { name: "HBV Vaccination 3", atc_codes: ["J07BC%"] },
        hbv4: { name: "HBV Vaccination 4", atc_codes: ["J07BC%"] },
        hbv_booster: { name: "HBV Booster", atc_codes: ["J07BM%"] },
        influenza: { name: "Influenza", atc_codes: ["J07BB%"] },
        pneumococcus: { name: "Pneumococcus", atc_codes: ["J07AL%"] },
        covid19_1: { name: "COVID-19 1", atc_codes: ["J07BN%"] },
        covid19_2: { name: "COVID-19 2", atc_codes: ["J07BN%"] },
        patient_refused: { name: "Patient Refused" },
        patient_refused_covid19: { name: "Patient refused Covid-19 vaccine", atc_codes: ["J07BN%"] },
        patient_refused_covid19_pfizer: { name: "Patient refused Covid-19 vaccine Pfizer", atc_codes: ["J07BN%"] },
        patient_refused_covid19_astrazenica: { name: "Patient refused Covid-19 vaccine Astra Zeneca", atc_codes: ["J07BN%"] }
      }.each do |code, hash|
        VaccinationType.find_or_create_by!(
          code: code,
          name: hash[:name],
          atc_codes: hash.fetch(:atc_codes, [])
        )
      end
    end
  end
end

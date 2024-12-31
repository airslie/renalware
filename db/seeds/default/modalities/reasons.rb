require_relative "../../seeds_helper"

module Renalware
  module Modalities
    Rails.benchmark "Adding PD To Haemodialysis (Reasons for Change)" do
      PDToHaemodialysis.find_or_create_by!(rr_code: 201, description: "Patient/partner choice")
      PDToHaemodialysis.find_or_create_by!(rr_code: 202, description: "Loss of supporting partner")
      PDToHaemodialysis.find_or_create_by!(rr_code: 203, description: "Other change of personal circumstances")
      PDToHaemodialysis.find_or_create_by!(rr_code: 204, description: "Inability to perform PD")
      PDToHaemodialysis.find_or_create_by!(rr_code: 205, description: "Other reasons")
      PDToHaemodialysis.find_or_create_by!(rr_code: 211, description: "Frequent/Recurrent peritonitis with or without loss of UF")
      PDToHaemodialysis.find_or_create_by!(rr_code: 212, description: "Unresolving peritonitis")
      PDToHaemodialysis.find_or_create_by!(rr_code: 213, description: "Catheter loss through exit site infection")
      PDToHaemodialysis.find_or_create_by!(rr_code: 214, description: "Loss of UF")
      PDToHaemodialysis.find_or_create_by!(rr_code: 215, description: "Inadequate clearance")
      PDToHaemodialysis.find_or_create_by!(rr_code: 216, description: "Abdominal surgery or complications")
    end

    Rails.benchmark "Adding Haemodialysis To PD (Reasons for Change)" do
      HaemodialysisToPD.find_or_create_by!(rr_code: 221, description: "Patient/partner choice")
      HaemodialysisToPD.find_or_create_by!(rr_code: 222, description: "Loss of supporting partner")
      HaemodialysisToPD.find_or_create_by!(rr_code: 223, description: "Other change of personal circumstances")
      HaemodialysisToPD.find_or_create_by!(rr_code: 224, description: "Lack of HD facilities")
      HaemodialysisToPD.find_or_create_by!(rr_code: 225, description: "Other reasons")
      HaemodialysisToPD.find_or_create_by!(rr_code: 231, description: "Loss of vascular access")
      HaemodialysisToPD.find_or_create_by!(rr_code: 232, description: "Haemodynamic instability")
      HaemodialysisToPD.find_or_create_by!(rr_code: 233, description: "Elective after temporary HD")
    end
  end
end

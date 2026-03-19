module Renalware
  Rails.benchmark "Adding Renal Profile and Comorbidities for Roger RABBIT" do
    Renal::Profile.create!(
      patient_id: 1,
      esrf_on: 17.weeks.ago,
      weight_at_esrf: 56.7,
      modality_at_esrf: "HD",
      first_seen_on: 18.weeks.ago,
      prd_description_id: 142,
      comorbidities_updated_on: 1.week.ago,
      document: {
        comorbidities: {
          diabetes: { status: "yes", confirmed_on_year: 2003 },
          ischaemic_heart_dis: { status: "yes", confirmed_on_year: 2003 },
          cabg_or_angioplasty: { status: "yes", confirmed_on_year: 2005 },
          heart_failure: { status: "yes", confirmed_on_year: 2004 },
          atrial_fibrill: { status: "no", confirmed_on_year: "" },
          malignancy: { status: "no", confirmed_on_year: "" },
          cerebrovascular_dis: { status: "no", confirmed_on_year: "" },
          chronic_obstr_pulm_dis: { status: "no", confirmed_on_year: "" },
          liver_disease: { status: "no", confirmed_on_year: "" },
          periph_vascular_dis: { status: "yes", confirmed_on_year: 2004 },
          amputation_for_pvd: { status: "no", confirmed_on_year: "" },
          claudication: { status: "no", confirmed_on_year: "" },
          ischaemic_neuropathic_ulcers: { status: "no", confirmed_on_year: "" },
          non_coronary_intervention: { status: "no", confirmed_on_year: "" },
          dementia: { status: "no", confirmed_on_year: "" }
        }
      }
    )
  end
end

require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Transplant Registration Statuses" do
    # HC on #1664: The only difficulty is for patients who receive a pre-emptive transplant so
    # their ESRF date is the date of their transplant. The RR list does not
    # accommodate that but I would put them as On Transplant List (3)
    #
    # RR ESR61 codes:
    # 1 Unsuitable
    # 2 Working Up or under discussion
    # 3 On Transplant List
    # 4 Suspended on Transplant List
    # 5 Not Assessed by Start of Dialysis
    statuses = [
      [:active, "Active", 3, "ESRF61: On Transplant List"],
      [:suspended, "Suspended", 4, "ESRF61: Suspended on Transplant List"],
      [:transplanted, "Transplanted", nil, "Not relevant for ESRF61"],
      [:live_transplanted, "Live transplanted", nil, "Not relevant for ESRF61"],
      [:off_by_patient, "Off by patient request", 1, "ERF61: Unsuitable"],
      [:not_eligible, "Not eligible for NHS Tx", 1, "ERF61: Unsuitable"],
      [:unfit_reconsider, "Unfit (not listed -- reconsider)", 1, "ERF61: Unsuitable"],
      [:unfit_permanent, "Unfit (not listed -- permanent)", 1, "ERF61: Unsuitable"],
      [:working_up, "X - working up", 2, "ERF61: Working Up or under discussion"],
      [:working_up_lrf, "X - working up LRF", 2, "ERF61: Working Up or under discussion"],
      [:not_for_work_up, "Not for work up - eGFR too high", 1, "ERF61: Unsuitable"],
      [:workup_complete, "Workup complete - low creat", 2, "ERF61: Working Up or under discussion"],
      [:transfer_out, "Transfer Out", nil, "Not relevant for ESRF61"],
      [:died, "Died", nil, "Not relevant for ESRF61"]
    ]

    statuses.each_with_index do |status, index|
      Transplants::RegistrationStatusDescription.find_or_create_by(code: status[0]) do |desc|
        desc.name = status[1]
        desc.rr_code = status[2]
        desc.rr_comment = status[3]
        desc.position = index * 10
      end
    end
  end
end

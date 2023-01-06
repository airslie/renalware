# frozen_string_literal: true

module Renalware
  log "Adding Pathology Code Groups" do
    user = User.first

    groups = {
      pd_pet_serum_pathology: {
        description: "Pathology relating to serum taken during a PD PET test." \
                     "position_within_subgroup determines the order inputs are " \
                     "populated in the PET pathology form.",
        subgroups: %w(URE CRE PGLU NA POT)
      },
      hd_session_form_recent: {
        description: "Recent pathology shown on the HD Sessions PDF print-out",
        subgroups: [
          %w(HGB PLT CRP POT CCA FER)
        ]
      },
      letters: {
        description: "Pathology shown on clinical letters",
        subgroups: [
          %w(HGB WBC PLT),
          %w(URE),
          %w(CRE EGFR),
          %w(NA POT),
          %w(BIC),
          %w(CCA PHOS),
          %w(PTHI),
          %w(ALB),
          %w(BIL AST ALP GGT),
          %w(HBA),
          %w(CHOL)
        ]
      },
      default: {
        description: "Default codes used for example in historical, recent and current pathology",
        subgroups: [
          %w(FOL ESR CRP FER HGB B12 MCV MCH HYPO WBC LYM NEUT PLT RETA),
          %w(URAT ALB TP GLO URE CRE EGFR NA POT BIC CCA PHOS PTHI ACR),
          %w(BIL ALT AST ALP GGT BGLU HBA HBAI CHOL HDL LDL TRIG TSH CK URR CRCL UREP AL)
        ]
      }
    }

    user = User.first

    groups.each do |name, options|
      group = Pathology::CodeGroup.find_or_create_by!(name: name) do |grp|
        grp.description = options[:description]
        grp.created_by = user
        grp.updated_by = user
      end

      Array(options[:subgroups]).each_with_index do |codes, subgrp_number|
        Array(codes).each_with_index do |code, position|
          membership = group.memberships.build
          membership.observation_description = Pathology::ObservationDescription.find_by(code: code)
          membership.subgroup = subgrp_number + 1
          membership.position_within_subgroup = position + 1
          membership.save_by! user
        end
      end
    end
  end
end

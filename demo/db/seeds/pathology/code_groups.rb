# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module Renalware
  log "Adding Pathology Code Groups" do
    groups = {
      pd_mdm: {
        description: "Pathology relating to PD",
        title: "PD",
        context_specific: false,
        subgroups: [
          %w(HGB WBC FER PLT URE CRE PGLU NA POT),
          %w(CCA PHOS)
        ],
        subgroup_colours: %(red sky),
        subgroup_titles: nil
      },
      hd_mdm: {
        description: "Pathology relating to HD",
        title: "HD",
        context_specific: false,
        subgroups: [
          %w(HGB WBC PLT URE CRE PGLU NA POT),
          %w(URAT ALB TP GLO EGFR KFRE2 KFRE5 Kt/V eKt/V spKt/V ceKt/V)
        ],
        subgroup_colours: %(red sky),
        subgroup_titles: nil
      },
      transplant_mdm: {
        description: "Pathology relating to Transplant",
        title: "Transplant",
        context_specific: false,
        subgroups: [%w(HGB WBC PLT URE CRE PGLU NA POT)],
        subgroup_colours: %(red),
        subgroup_titles: nil
      },
      pd_pet_serum_pathology: {
        description: "Pathology relating to serum taken during a PD PET test." \
                     "position_within_subgroup determines the order inputs are " \
                     "populated in the PET pathology form.",
        title: "PD PET serum",
        context_specific: true,
        subgroups: %w(URE CRE PGLU NA POT),
        subgroup_colours: %(green),
        subgroup_titles: nil
      },
      hd_session_form_recent: {
        description: "Recent pathology shown on the HD Sessions PDF print-out",
        title: "HD Session printable form",
        context_specific: true,
        subgroups: [
          %w(HGB PLT CRP POT CCA FER),
          %w(BIL AST ALP GGT)
        ],
        subgroup_colours: nil,
        subgroup_titles: nil
      },
      letters: {
        description: "Pathology shown on clinical letters",
        title: "Letters",
        context_specific: true,
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
        ],
        subgroup_colours: nil,
        subgroup_titles: nil
      },
      hep_b_antibody_statuses: {
        description: "Latest Hep B Surface Antibody Titre",
        context_specific: true,
        subgroups: %w(BHBS),
        subgroup_colours: []
      },
      default: {
        description: "Default codes used for example in historical, recent and current pathology",
        title: "Default",
        context_specific: false,
        subgroups: [
          %w(FOL ESR CRP FER HGB B12 MCV MCH HYPO WBC LYM NEUT PLT RETA),
          %w(URAT ALB TP GLO URE CRE EGFR KFRE2 KFRE5 Kt/V eKt/V spKt/V ceKt/V
             NA POT BIC CCA PHOS PTHI ACR),
          %w(BIL ALT AST ALP GGT BGLU HBA HBAI CHOL HDL LDL TRIG TSH CK URR CRCL UREP AL)
        ],
        subgroup_colours: %w(red green sky),
        subgroup_titles: ["Subgroup1 title", "Subgroup2 title", "Subgroup3 title"]
      }
    }

    user = User.first

    groups.each do |name, options|
      group = Pathology::CodeGroup.find_or_create_by!(name: name) do |grp|
        grp.description = options[:description]
        grp.title = options[:title]
        grp.context_specific = options[:context_specific]
        grp.subgroup_colours = options[:subgroup_colours]
        grp.subgroup_titles = options[:subgroup_titles]
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
# rubocop:enable Metrics/ModuleLength

FactoryBot.define do
  factory :pathology_code_group, class: "Renalware::Pathology::CodeGroup" do
    accountable
    sequence(:name) { "Group#{it}" }
    description { "Group1Description" }

    trait :hd_session_form_recent do
      name { "hd_session_form_recent" }
    end

    trait :immunosuppressive do
      name { "immunosuppressive" }
      context_specific { true }
      subgroup_colours { nil }
      subgroup_titles { %w(Tacrolimus Cyclosporin) }
      memberships do
        [
          association(:pathology_code_group_membership, :ltax),
          association(:pathology_code_group_membership, :cya)
        ]
      end
    end

    trait :default do
      name { "default" }
      # association :member, factory: :pathology_code_group_membership, code: "FBC"
    end
  end
end

describe "renalware/virology/profiles/summary" do
  VIROLOGY_ATTRIBUTES = %i(hiv hepatitis_b hepatitis_b_core_antibody hepatitis_c htlv).freeze
  helper(Renalware::Engine.routes.url_helpers, Renalware::AttributeNameHelper)

  let(:patient) { create(:virology_patient).tap(&:create_profile) }
  let(:profile) { patient.profile }
  let(:user) { create(:user) }
  let(:partial) { "renalware/virology/profiles/summary" }

  context "when the patient has no HIV, HepB or HEPC in their clinical profile" do
    it "displays an empty Virology section" do
      profile
      render partial: partial, locals: { patient: patient, positive_results_only: true }

      VIROLOGY_ATTRIBUTES.each do |virology_attribute|
        expect(rendered).not_to include(human_virology_attribute_name_for(virology_attribute))
      end
    end
  end

  def human_virology_attribute_name_for(attr_name)
    attr_name(profile.document, attr_name)
  end

  VIROLOGY_ATTRIBUTES.each do |virology_attr|
    context "when the patient has #{virology_attr} only with a Year and year of 2011" do
      before do
        profile.document.public_send(virology_attr).status = :yes
        profile.document.public_send(virology_attr).confirmed_on_year = 2011
        profile.save_by!(user)
      end

      it "displays only #{virology_attr}, including the year" do
        render partial: partial, locals: { patient: patient, positive_results_only: true }

        expect(rendered).to include(human_virology_attribute_name_for(virology_attr))
        expect(rendered).to include("Yes (2011)")

        # The other ones should not be displayed
        (VIROLOGY_ATTRIBUTES - [virology_attr]).each do |absent_virology_attribute|
          expect(rendered).not_to include(
            ">#{human_virology_attribute_name_for(absent_virology_attribute)}<"
          )
        end
      end
    end
  end
end

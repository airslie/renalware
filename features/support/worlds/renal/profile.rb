module World
  module Renal::Profile
    module Domain
      def edit_renal_profile(user, patient)
        # noop
      end

      def update_renal_profile(user, patient)
        # noop
      end

      def expect_renal_profile_to_be_updated(user, patient)
        # noop
      end
    end

    module Web
      include Domain

      def edit_renal_profile(user, patient)
        login_as user
        visit edit_patient_renal_profile_path(patient)
      end

      def update_renal_profile(_user, patient)
        select2 "Cystinuria", css: ".renal_profile_prd_description"
        fill_in "ESRF Date", with: fake_date.to_s

        submit_form
        # within page.first(".form-actions") do
        #   click_on t("btn.save")
        # end

        expect(page).to have_current_path(patient_renal_profile_path(patient))
      end

      def expect_renal_profile_to_be_updated(_user, patient)
        profile = Renalware::Renal.cast_patient(patient).profile.reload

        expect(profile.esrf_on).to eq(fake_date)
        expect(profile.prd_description.term).to eq("Cystinuria")
      end

      private

      def low_clearance_t(key)
        scope = "activemodel.attributes.renalware/renal/profile_document/low_clearance"
        t(key, scope: scope)
      end
    end
  end
end

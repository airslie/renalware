module World
  module HD::MDM
    module Domain
      def view_patient_mdm_page(patient:, **)
        @mdm = Renalware::HD::MDMPresenter.new(patient: patient)
      end

      def expect_mdm_to_include_patient_sessions(patient:, table:)
        # expect(@mdm.sessions.count).to eqtable.
        expect(patient).to_not be_nil
        expect(@mdm.sessions.size).to eq(table.hashes.size)

        # entries = sessions.map do |session|
        #   hash = {
        #     patient: session.patient.to_s,
        #     signed_on_by: session.signed_on_by.given_name,
        #     signed_off_by: (session.signed_off_by.try(:given_name) || "")
        #   }
        #   hash.with_indifferent_access
        # end
        # hashes.each do |row|
        #   expect(entries).to include(row)
        # end
      end
    end

    module Web
      def view_patient_mdm_page(patient:, user:)
        login_as user
        visit patient_hd_mdm_path(patient)

        expect(page).to have_content(patient.given_name)
        expect(page).to have_content(patient.family_name)
      end

      def expect_mdm_to_include_patient_sessions(patient:, table:); end
    end
  end
end

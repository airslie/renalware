module World
  module HD::Session
    module Domain
      def create_dna_session(options)
        seed_dna_session(options)
      end

      def seed_dna_session(options)
        options = parse_options(options)
        Renalware::HD::Session::DNA.create!(options)
      end

      def expect_dna_session_to_exist(patient:)
        expect(Renalware::HD::Session::DNA.for_patient(patient)).to be_present
      end

      private

      def parse_options(options)
        options[:patient] = hd_patient(options[:patient])
        options[:signed_on_by] = options[:by] = options.delete(:user)
        options.reverse_merge!(default_dna_session_options)
      end

      def default_dna_session_options
        {
          notes: "none",
          hospital_unit: Renalware::Hospitals::Unit.hd_sites.first,
          started_at: Time.zone.now,
          document: {
            patient_on_holiday: "yes"
          }
        }
      end
    end

    module Web
      include Domain

      def create_dna_session(options)
        user = options.delete(:user)
        patient = options.delete(:patient)
        login_as user
        visit patient_hd_dashboard_path(patient)

        within ".page-actions" do
          click_on t("btn.add")
          click_on "DNA Session"
        end

        select hd_unit.to_s, from: t_form(".hospital_unit")
        fill_in t_form(".performed_on"), with: l(Time.zone.today)

        within ".hd_session_notes" do
          fill_in t_form(".notes"), with: options[:notes]
        end

        within ".hd_session_document_patient_on_holiday" do
          choose "Yes"
        end

        submit_form

        expect(page).to have_current_path(patient_hd_dashboard_path(patient))
        expect_dna_session_to_exist(patient: patient)
      end

      private

      def t_sessions(key)
        I18n.t!(key, scope: "renalware.hd.sessions.list")
      end

      def t_form(key)
        I18n.t!(key, scope: "activerecord.attributes.renalware/hd/session")
      rescue I18n::MissingTranslationData
        I18n.t(key, scope: "renalware.hd.sessions.dna.form")
      end
    end
  end
end

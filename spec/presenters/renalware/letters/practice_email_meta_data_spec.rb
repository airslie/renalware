module Renalware
  describe Letters::PracticeEmailMetaData do
    include LettersSpecHelper

    let(:user) do
      build_stubbed(
        :user,
        family_name: "Bach",
        given_name: "Johann Sebastian",
        signature: "Johann S. Bach"
      )
    end
    let(:practice) { build(:practice, code: "PRAC1") }
    let(:primary_care_physician) do
      build(:primary_care_physician, code: "G123").tap { |gp| gp.practices << practice }
    end
    let(:patient) do
      build(
        :letter_patient,
        family_name: "Jones",
        given_name: "Tom",
        local_patient_id: "Z123",
        nhs_number: "9999999999",
        born_on: "01-Feb-1967",
        by: user
      )
    end

    let(:letter) {
      build_letter(
        patient: patient,
        to: primary_care_physician,
        approved_at: "01-Jan-2018 11:00:01",
        author: user,
        description: "LetterDescription",
        by: user
      )
    }

    describe ".to_s which builds an IDENT string describing the letter attachment in the email, " \
             "and which will be parsed at the practice to file the letter appropriately" do
      context "when config defaults are assumed" do
        it "renders the IDENT using defaults for missing arguments" do
          allow(letter).to receive(:id).and_return(111)

          # care_group_name and letter_system_name are not supplied so config values will be used
          metadata = described_class.new(
            letter: letter,
            primary_care_physician: primary_care_physician,
            practice: practice
          )

          Renalware.configure do |config|
            config.letter_system_name = "ConfiguredSystem"
            config.letter_default_care_group_name = "ConfiguredCareGroup"
            config.hospital_name = "ConfiguredHospitalName"
          end

          visit_or_letter_date = "01/01/2018" # letter.approved_at

          expect(metadata.to_s).to eq(
            "<IDENT>" \
            "PRAC1|" \
            "Jones|" \
            "Tom|" \
            "Z123|" \
            "9999999999|" \
            "01/02/1967|" \
            "ConfiguredHospitalName|" \
            "ConfiguredSystem|" \
            "#{visit_or_letter_date}|" \
            "LetterDescription|" \
            "111|" \
            "Bach, Johann Sebastian|" \
            "01/01/2018|" \
            "G123|" \
            "ConfiguredCareGroup|" \
            "Johann S. Bach" \
            "</IDENT>"
          )
        end
      end

      context "when all arguments are supplied to the initializer" do
        it "these override the defaults" do
          allow(letter).to receive(:id).and_return(111)

          metadata = described_class.new(
            letter: letter,
            primary_care_physician: primary_care_physician,
            practice: practice,
            hospital_name: "MyHospital",
            care_group_name: "MyCareGroup",
            letter_system_name: "MySystem"
          )

          visit_or_letter_date = "01/01/2018" # letter.approved_at

          expect(metadata.to_s).to eq(
            "<IDENT>" \
            "PRAC1|" \
            "Jones|" \
            "Tom|" \
            "Z123|" \
            "9999999999|" \
            "01/02/1967|" \
            "MyHospital|" \
            "MySystem|" \
            "#{visit_or_letter_date}|" \
            "LetterDescription|" \
            "111|" \
            "Bach, Johann Sebastian|" \
            "01/01/2018|" \
            "G123|" \
            "MyCareGroup|" \
            "Johann S. Bach" \
            "</IDENT>"
          )
        end
      end

      context "when the patient has no primary care physician" do
        it "does not error as this is expected" do
          allow(letter).to receive(:id).and_return(111)

          metadata = described_class.new(
            letter: letter,
            primary_care_physician: nil,
            practice: practice,
            hospital_name: "MyHospital",
            care_group_name: "MyCareGroup",
            letter_system_name: "MySystem"
          )

          visit_or_letter_date = "01/01/2018"

          expect(metadata.to_s).to eq(
            "<IDENT>" \
            "PRAC1|" \
            "Jones|" \
            "Tom|" \
            "Z123|" \
            "9999999999|" \
            "01/02/1967|" \
            "MyHospital|" \
            "MySystem|" \
            "#{visit_or_letter_date}|" \
            "LetterDescription|" \
            "111|" \
            "Bach, Johann Sebastian|" \
            "01/01/2018|" \
            "|" \
            "MyCareGroup|" \
            "Johann S. Bach" \
            "</IDENT>"
          )
        end
      end

      context "when the patient has no practice" do
        it "does not error as this is possible, though unlikely" do
          allow(letter).to receive(:id).and_return(111)

          metadata = described_class.new(
            letter: letter,
            primary_care_physician: nil,
            practice: nil,
            hospital_name: "MyHospital",
            care_group_name: "MyCareGroup",
            letter_system_name: "MySystem"
          )

          visit_or_letter_date = "01/01/2018"

          expect(metadata.to_s).to eq(
            "<IDENT>" \
            "|" \
            "Jones|" \
            "Tom|" \
            "Z123|" \
            "9999999999|" \
            "01/02/1967|" \
            "MyHospital|" \
            "MySystem|" \
            "#{visit_or_letter_date}|" \
            "LetterDescription|" \
            "111|" \
            "Bach, Johann Sebastian|" \
            "01/01/2018|" \
            "|" \
            "MyCareGroup|" \
            "Johann S. Bach" \
            "</IDENT>"
          )
        end
      end

      context "when the letter has a clinic visit event" do
        it "outputs the clinic visit date" do
          allow(letter).to receive(:id).and_return(111)

          visit_date = "01/01/2017"
          clinic_visit = build_stubbed(:clinic_visit, patient_id: patient.id, date: visit_date)
          letter.event = Letters::Event::ClinicVisit.new(clinic_visit, clinical: true)

          metadata = described_class.new(
            letter: letter,
            primary_care_physician: primary_care_physician,
            practice: practice
          )

          Renalware.configure do |config|
            config.letter_system_name = "ConfiguredSystem"
            config.letter_default_care_group_name = "ConfiguredCareGroup"
            config.hospital_name = "ConfiguredHospitalName"
          end

          expect(metadata.to_s).to eq(
            "<IDENT>" \
            "PRAC1|" \
            "Jones|" \
            "Tom|" \
            "Z123|" \
            "9999999999|" \
            "01/02/1967|" \
            "ConfiguredHospitalName|" \
            "ConfiguredSystem|" \
            "#{visit_date}|" \
            "LetterDescription|" \
            "111|" \
            "Bach, Johann Sebastian|" \
            "01/01/2018|" \
            "G123|" \
            "ConfiguredCareGroup|" \
            "Johann S. Bach" \
            "</IDENT>"
          )
        end
      end
    end
  end
end

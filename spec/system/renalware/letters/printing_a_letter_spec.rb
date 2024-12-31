describe "Printing a letter", :js do
  include LettersSpecHelper
  include AjaxHelpers

  def stub_out_pdf_generation
    unless Renalware.config.letters_render_pdfs_with_prawn
      allow(Renalware::Letters::PdfLetterCache)
        .to receive(:fetch)
        .and_return("dummy pdf content")
    end
  end

  def expect_a_pdf_to_have_been_generated_in_another_tab
    unless Renalware.config.letters_render_pdfs_with_prawn
      expect(Renalware::Letters::PdfLetterCache).to have_received(:fetch)
    end
  end

  def create_an_approved_letter_ready_for_printing(user, patient)
    create_letter(
      to: :patient,
      state: :approved,
      patient: Renalware::Letters.cast_patient(patient),
      description: "approved letter",
      by: user
    )
  end

  def create_an_already_complete_letter_we_will_filter_out(user, patient)
    create_letter(
      to: :patient,
      state: :completed,
      patient: Renalware::Letters.cast_patient(patient),
      description: "completed letter",
      by: user
    )
  end

  describe "when a user prints an item in renal letters list and chooses to mark it as printed" do
    it "marks the letter as complete and removes it form the Approved list (filter)" do
      user = login_as_clinical
      patient = create(:patient, family_name: "Rabbit", by: user)
      approved_letter = create_an_approved_letter_ready_for_printing(user, patient)
      create_an_already_complete_letter_we_will_filter_out(user, patient)
      stub_out_pdf_generation

      visit letters_list_path

      # Initially we'll see both approved and completed letters
      within("table.letters") do
        expect(page).to have_css("tbody tr", count: 2)
      end

      # filter so we only see approved letters
      within(".search-form.filters") do
        select "Approved (Ready to Print)", from: "State"
      end

      wait_for_turbo_frame "letter-lists-turbo-frame"

      within("table.letters") do
        expect(page).to have_content("RABBIT")
        # TODO: Approved select above should trigger form submit! but does not
        # so filter not applied and still two rows here
        # expect(page).to have_css("tbody tr", count: 1)

        # Print the letter
        click_on t("btn.print")
      end

      # In 'real life' the browser launches a PDF in a new tab
      # And we display a print confirmation modal on this page.
      # Here in chrome driver land we stay o the same page but another
      # tab does kick off and try and render the PDF - hence we stub out
      # PDF generation above. But we don't need to worry about that,
      # just check later that a pdf was generated.
      # NOTE: don't change this to have_current_path - we need to use match here
      # rubocop:disable Capybara/CurrentPathExpectation
      expect(page.current_path).to match(letters_list_path)
      # rubocop:enable Capybara/CurrentPathExpectation

      within(".modal") do
        expect(page).to have_content("Was printing successful?")
        click_on "Yes - remove from the Print Queue"
      end

      wait_for_turbo_frame "letter-lists-turbo-frame"

      within("table.letters") do
        # TODO: Approved select above should trigger form submit! but does not
        # so filter not applied and still two rows here
        # expect(page).to have_css("tbody tr", count: 0)
      end

      letter = Renalware::Letters::Letter.find(approved_letter.id)
      expect(letter).to be_completed
      expect_a_pdf_to_have_been_generated_in_another_tab
    end
  end

  describe "when a user prints an item in renal letters list but chooses not to mark as printed" do
    it "leaves the letter as Approved" do
      user = login_as_clinical
      patient = create(:patient, family_name: "Rabbit", by: user)
      approved_letter = create_an_approved_letter_ready_for_printing(user, patient)
      create_an_already_complete_letter_we_will_filter_out(user, patient)
      stub_out_pdf_generation

      visit letters_list_path

      # Initially we'll see both approved and completed letters
      within("table.letters") do
        expect(page).to have_css("tbody tr", count: 2)
      end

      # filter so we only see approved letters
      within(".search-form.filters") do
        select "Approved (Ready to Print)", from: "State"
      end

      wait_for_turbo_frame "letter-lists-turbo-frame"

      within("table.letters") do
        expect(page).to have_content("RABBIT")
        # TODO: select above should trigger form submit! but does not
        # so filter not applied and still two rows here
        # expect(page).to have_css("tbody tr", count: 1)

        # Print the letter
        click_on t("btn.print")
      end

      # NOTE: don't change this to have_current_path - we need to use match here
      # rubocop:disable Capybara/CurrentPathExpectation
      expect(page.current_path).to match(letters_list_path)
      # rubocop:enable Capybara/CurrentPathExpectation

      within(".modal") do
        expect(page).to have_content("Was printing successful?")
        click_on "No - leave in the Print Queue"
      end

      expect(page).to have_no_content("Was printing successful?")
      within("table.letters") do
        # TODO: select above should trigger form submit! but does not
        # so filter not applied and still two rows here
        # expect(page).to have_css("tbody tr", count: 1)
      end

      # Letter remains approved
      letter = Renalware::Letters::Letter.find(approved_letter.id)
      expect(letter).to be_approved
      expect_a_pdf_to_have_been_generated_in_another_tab
    end
  end
end

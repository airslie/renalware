describe "Managing Dialysates" do
  describe "creating a new dialysate" do
    it do
      login_as_super_admin

      visit admin_dashboard_path

      within ".side-nav--admin" do
        click_on "Dialysates"
      end

      click_on t("btn.add")

      fill_in "Name", with: "a name"
      fill_in "Description", with: "a description"
      fill_in "dialysate[sodium_content]", with: "111"
      fill_in "Sodium content uom", with: "mmol/L"
      fill_in "dialysate[bicarbonate_content]", with: "222.2"
      fill_in "Bicarbonate content uom", with: "mmol/L"
      fill_in "dialysate[calcium_content]", with: "333.3"
      fill_in "Calcium content uom", with: "mmol/L"
      fill_in "dialysate[potassium_content]", with: "444.4"
      fill_in "Potassium content uom", with: "mmol/L"

      click_on t("btn.create")

      within ".hd-dialysates tbody" do
        expect(page).to have_content("a name")
        expect(page).to have_content("a description")
        expect(page).to have_content("111 mmol/L")
        expect(page).to have_content("222.2 mmol/L")
        expect(page).to have_content("333.3 mmol/L")
        expect(page).to have_content("444.4 mmol/L")
      end
    end
  end

  describe "editing a dialysate" do
    it do
      create(:hd_dialysate)

      login_as_super_admin
      visit hd_dialysates_path

      within ".hd-dialysates tbody" do
        click_on t("btn.edit")
      end

      fill_in "Name", with: "a new name"
      fill_in "Description", with: "a new description"
      click_on t("btn.save")

      within ".hd-dialysates tbody" do
        expect(page).to have_content("a new name")
        expect(page).to have_content("a new description")
      end
    end
  end
end

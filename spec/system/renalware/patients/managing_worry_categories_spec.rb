# frozen_string_literal: true

describe "Worry Category Management" do
  it "displays a list of worry categories" do
    user = login_as_super_admin
    category = create(:worry_category, by: user, name: "Cat123")

    visit worry_categories_path

    expect(page).to have_http_status(:success)
    expect(page).to have_current_path(worry_categories_path)

    within "#worry_categories" do
      expect(page).to have_content(category.name)
      expect(page).to have_content(user.family_name)
      expect(page).to have_content(I18n.l(category.updated_at))
    end
  end

  it "edit a worry category" do
    user = login_as_super_admin
    create(:worry_category, by: user, name: "Cat123")

    visit worry_categories_path

    within "#worry_categories" do
      click_on t("btn.edit")
    end

    fill_in "Name", with: "NewName"
    click_on t("btn.save")

    within "#worry_categories" do
      expect(page).to have_content("NewName")
    end
  end

  it "add a category" do
    login_as_super_admin

    visit worry_categories_path

    within ".page-actions" do
      click_on t("btn.add")
    end

    fill_in "Name", with: "NewName"
    click_on t("btn.create")

    within "#worry_categories" do
      expect(page).to have_content("NewName")
    end
  end

  it "soft delete a category" do
    user = login_as_super_admin
    category = create(:worry_category, by: user, name: "Cat123")

    visit worry_categories_path

    within "#worry_categories" do
      click_on t("btn.delete")
    end

    within "#worry_categories" do
      expect(page).to have_content(category.name) # row will display but be styled as deleted (red)
    end
  end
end

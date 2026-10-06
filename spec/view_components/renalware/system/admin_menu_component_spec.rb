describe Renalware::System::AdminMenuComponent, type: :component do
  around do |example|
    original = Renalware.config.heidi_enabled
    I18n.with_locale(:"en-GB") { example.run }
  ensure
    Renalware.config.heidi_enabled = original
  end

  it "has an en-GB translation for every configured label" do
    expect(missing_translation_keys).to be_empty
  end

  context "with a super-admin user" do
    it "renders accessible, searchable menu sections" do
      render_inline(described_class.new(current_user: create(:user, :super_admin)))

      expect(page).to have_field("Search admin menu")
      expect(page).to have_css("details > summary", text: "HD")
      expect(page).to have_css("details > summary", text: "Feeds")
      expect(page).to have_css("details > summary", text: "System")
      expect(page).to have_link("Transmission Logs", visible: :all)
      expect(page).to have_link("Logs", exact: true, visible: :all)
      expect(page).to have_link("API Logs", visible: :all)
      expect(page.find(".access-configuration", visible: :all))
        .to have_link("Clinic Mappings", href: clinic_mappings_path, visible: :all)
      expect(page).to have_link("UKRDC Logs", visible: :all)
    end

    it "places User Management immediately below Dashboard" do
      render_inline(described_class.new(current_user: create(:user, :super_admin)))

      expect(page).to have_css(
        ".side-nav--admin > .admin-menu__item:first-child",
        text: "Dashboard"
      )
      expect(page).to have_css(
        ".side-nav--admin > .admin-menu__section:nth-child(2) > details > summary",
        text: "User Management"
      )
      expect(page).to have_link("Users", visible: :all)
      expect(page).to have_link("User Groups", visible: :all)
    end

    it "places Clinic Mappings immediately after Clinics in Configuration" do
      render_inline(described_class.new(current_user: create(:user, :super_admin)))

      links = page.all(".access-configuration a", visible: :all).map(&:text)
      expect(links[links.index("Clinics") + 1]).to eq("Clinic Mappings")
      expect(page).to have_no_css(".clinics", visible: :all)
    end

    it "prefixes Dashboard with a decorative icon" do
      render_inline(described_class.new(current_user: create(:user, :super_admin)))

      dashboard_link = page.find_link("Dashboard")

      expect(dashboard_link).to have_css("svg[aria-hidden='true']")
      expect(dashboard_link.text(normalize_ws: true)).to eq("Dashboard")
    end

    it "orders items within each section by their sort key or translated name" do
      component = described_class.new(current_user: create(:user, :super_admin))
      render_inline(component)

      expect(unordered_section_titles(component)).to be_empty
    end

    it "adds section names and aliases to each item's search text" do
      render_inline(described_class.new(current_user: create(:user, :super_admin)))

      api_logs = page.find(
        "[data-admin-menu-filter-target='item']",
        text: "API Logs",
        visible: :all
      )
      gps = page.find(
        "[data-admin-menu-filter-target='item']",
        text: "GPs",
        exact_text: true,
        visible: :all
      )

      expect(api_logs["data-search-text"]).to include("System API Logs requests")
      expect(gps["data-search-text"]).to include("primary care physicians")
    end

    it "renders Outgoing Documents in one section only" do
      render_inline(described_class.new(current_user: create(:user, :super_admin)))

      expect(page).to have_link("Outgoing Documents", count: 1, visible: :all)
    end

    it "opens the section containing the active page" do
      component = described_class.new(current_user: create(:user, :super_admin))

      render_component_at(component, system_api_logs_path)

      expect(page).to have_css(".system details[open]")
      expect(page).to have_css(".system .admin-menu__item.active", text: "API Logs")
    end

    it "hides Heidi menu items when Heidi is disabled" do
      Renalware.config.heidi_enabled = false

      render_inline(described_class.new(current_user: create(:user, :super_admin)))

      expect(page).to have_no_link("Heidi Sessions", visible: :all)
      expect(page).to have_no_link("Heidi Usage", visible: :all)
    end

    it "renders Heidi menu items when Heidi is enabled" do
      Renalware.config.heidi_enabled = true

      render_inline(described_class.new(current_user: create(:user, :super_admin)))

      expect(page).to have_link("Heidi Sessions", visible: :all)
      expect(page).to have_link("Heidi Usage", visible: :all)
    end
  end

  context "with an admin user" do
    it "does not render super-admin items in the searchable DOM" do
      render_inline(described_class.new(current_user: create(:user, :admin)))

      expect(page).to have_link("Users", visible: :all)
      expect(page).to have_link("Transmission Logs", visible: :all)
      expect(page).to have_no_link("API Logs", visible: :all)
      expect(page).to have_no_link("UKRDC Logs", visible: :all)
      expect(page).to have_no_link("User Groups", visible: :all)
      expect(page).to have_no_link("Clinic Mappings", visible: :all)
    end
  end

  context "with a clinical user" do
    it "does not render the admin menu" do
      render_inline(described_class.new(current_user: create(:user, :clinical)))

      expect(page).to have_no_css(".admin-menu")
    end
  end

  def render_component_at(component, path)
    with_request_url(path) { render_inline(component) }
  end

  def missing_translation_keys
    config = described_class::MENU_CONFIG
    scope = described_class::I18N_SCOPE
    keys = config.fetch(:primary).map { |item| "#{scope}.primary.#{item.fetch(:key)}" }

    config.fetch(:sections).each do |section|
      section_scope = "#{scope}.sections.#{section.fetch(:key)}"
      keys << "#{section_scope}.title"
      keys.concat(section.fetch(:items).map { |item| "#{section_scope}.items.#{item.fetch(:key)}" })
    end

    keys.reject { |key| I18n.exists?(key, :"en-GB") }
  end

  def unordered_section_titles(component)
    component.menu_sections.filter_map do |section|
      titles = section.items.map { |item| item.sort_key || item.title }
      section.title unless titles == titles.sort_by(&:downcase)
    end
  end
end

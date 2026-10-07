module Renalware::Pathology
  describe "Designing pathology code groups" do
    def create_description(code, name = code.downcase.capitalize)
      create(:pathology_observation_description, code:, name:)
    end

    def add_member(group, code, **attrs)
      create(
        :pathology_code_group_membership,
        code_group: group,
        observation_description: create_description(code),
        **attrs
      )
    end

    describe "listing code groups" do
      it "lists all groups including system groups" do
        create(:pathology_code_group, name: "Group1", description: "TheDesc", title: "ABC")
        create(:pathology_code_group, name: "letters", context_specific: true)
        login_as_super_admin

        visit pathology_code_groups_path

        within ".code-groups-table" do
          expect(page).to have_text "Group1"
          expect(page).to have_text "ABC"
          expect(page).to have_text "TheDesc"
          expect(page).to have_text "letters"
        end
        expect(page).to have_link "New code group"
      end

      it "is forbidden to non super admins" do
        login_as_admin

        visit pathology_code_groups_path

        expect(page).to have_text "not authorized"
      end
    end

    describe "viewing a code group" do
      it "shows the preview and members" do
        group = create(:pathology_code_group, name: "Group1", title: "G1",
                                              subgroup_titles: %w(Bone), subgroup_colours: %w(lime))
        add_member(group, "PTH")
        login_as_super_admin

        visit pathology_code_group_path(group)

        expect(page).to have_text "Group1"
        expect(page).to have_text "Bone"
        expect(page).to have_text "PTH"
        expect(page).to have_css(".border-l-lime-300")
      end
    end

    describe "creating a code group" do
      it "saves name, title, description, subgroup and members" do
        create_description("HGB", "Haemoglobin")
        create_description("PTH", "Parathyroid hormone")
        login_as_super_admin

        visit new_pathology_code_group_path
        fill_in "Name", with: "transplant"
        fill_in "Title", with: "Transplant"
        fill_in "Description", with: "Transplant results"
        fill_in "Subgroup 1 title", with: "Bloods"
        select "lime", from: "Subgroup 1 colour"
        select "HGB – Haemoglobin", from: "Result to add"
        click_on "Add result"
        select "PTH – Parathyroid hormone", from: "Result to add"
        click_on "Add result"
        click_on t("btn.save")

        group = CodeGroup.find_by!(name: "transplant")
        expect(group).to have_attributes(
          title: "Transplant",
          description: "Transplant results",
          subgroup_titles: ["Bloods"],
          subgroup_colours: ["lime"],
          context_specific: false
        )
        placements = group.memberships.map do |member|
          [member.observation_description.code, member.subgroup, member.position_within_subgroup]
        end
        expect(placements).to eq [["HGB", 1, 1], ["PTH", 1, 2]]
      end

      it "shows validation errors and keeps the draft" do
        create_description("HGB", "Haemoglobin")
        login_as_super_admin

        visit new_pathology_code_group_path
        fill_in "Name", with: "x"
        select "HGB – Haemoglobin", from: "Result to add"
        click_on "Add result"
        click_on t("btn.save")

        expect(page).to have_text "can't be blank"
        expect(page).to have_css("tr.membership", text: "HGB")
        expect(CodeGroup.find_by(name: "x")).to be_nil
      end
    end

    describe "editing a code group" do
      let!(:group) do
        create(:pathology_code_group, name: "Group1", title: "G1", description: "TheDesc",
                                      subgroup_titles: %w(One), subgroup_colours: [nil])
      end

      it "changes description and locks the name" do
        login_as_super_admin

        visit edit_pathology_code_group_path(group)

        expect(page).to have_field("Name", disabled: true, with: "Group1")
        fill_in "Description", with: "Changed description"
        click_on t("btn.save")

        expect(group.reload.description).to eq "Changed description"
      end

      it "adds a subgroup then a member to it" do
        create_description("HGB", "Haemoglobin")
        login_as_super_admin

        visit edit_pathology_code_group_path(group)
        click_on "Add subgroup"
        fill_in "Subgroup 2 title", with: "Second"
        select "HGB – Haemoglobin", from: "Result to add"
        select "2", from: "In subgroup"
        click_on "Add result"
        click_on t("btn.save")

        group.reload
        expect(group.subgroup_titles).to eq %w(One Second)
        expect(group.memberships.map { [it.observation_description.code, it.subgroup] })
          .to eq [["HGB", 2]]
      end

      it "removes a member only when saved" do
        membership = add_member(group, "HGB")
        login_as_super_admin

        visit edit_pathology_code_group_path(group)
        click_on "Remove HGB"
        expect(page).to have_no_css("tr.membership", text: "HGB")
        expect(CodeGroupMembership.exists?(membership.id)).to be true

        click_on t("btn.save")

        expect(CodeGroupMembership.exists?(membership.id)).to be false
      end

      it "opens a group whose subgroup titles and colours are null" do
        group.update_columns(subgroup_titles: nil, subgroup_colours: nil)
        add_member(group, "HGB")
        login_as_super_admin

        visit edit_pathology_code_group_path(group)

        expect(page).to have_field("Subgroup 1 title")
        visit pathology_code_group_path(group)
        expect(page).to have_text "HGB"
      end

      it "attributes added and reordered members to the current user" do
        hgb = add_member(group, "HGB")
        create_description("PTH", "Parathyroid hormone")
        user = login_as_super_admin

        visit edit_pathology_code_group_path(group)
        select "PTH – Parathyroid hormone", from: "Result to add"
        click_on "Add result"
        click_on t("btn.save")

        pth = group.reload.memberships.find { |m| m.observation_description.code == "PTH" }
        expect(pth).to have_attributes(created_by_id: user.id, updated_by_id: user.id)
        expect(hgb.reload.updated_by_id).not_to be_nil
      end

      it "keeps the session when draft actions are submitted with CSRF protection on" do
        login_as_super_admin
        original = ActionController::Base.allow_forgery_protection
        ActionController::Base.allow_forgery_protection = true

        visit edit_pathology_code_group_path(group)
        click_on "Add subgroup"

        expect(page).to have_field("Subgroup 2 title")
      ensure
        ActionController::Base.allow_forgery_protection = original
      end

      it "does not offer results already in the group" do
        add_member(group, "HGB")
        login_as_super_admin

        visit edit_pathology_code_group_path(group)

        expect(page).to have_select("Result to add")
        expect(page).to have_no_select("Result to add", with_options: ["HGB – Hgb"])
      end

      it "previews the draft without saving" do
        add_member(group, "HGB")
        login_as_super_admin

        visit edit_pathology_code_group_path(group)
        fill_in "Subgroup 1 title", with: "Draft title"
        select "red", from: "Subgroup 1 colour"
        click_on "Refresh preview"

        within "#code-group-preview" do
          expect(page).to have_text "Draft title"
          expect(page).to have_text "HGB"
          expect(page).to have_css(".border-l-red-300")
        end
        expect(group.reload.subgroup_titles).to eq %w(One)
      end

      it "lets a system group be edited but not renamed or deleted" do
        system_group = create(:pathology_code_group, name: "letters", description: "Old",
                                                     context_specific: true)
        login_as_super_admin

        visit edit_pathology_code_group_path(system_group)

        expect(page).to have_field("Name", disabled: true, with: "letters")
        expect(page).to have_no_button "Delete code group"
        fill_in "Title", with: "Letters"
        fill_in "Description", with: "New"
        click_on t("btn.save")

        expect(system_group.reload).to have_attributes(
          name: "letters", title: "Letters", description: "New", context_specific: true
        )
      end
    end

    describe "reordering by drag and drop", :js do
      it "moves a member to another subgroup and persists positions" do
        group = create(:pathology_code_group, title: "G", subgroup_titles: %w(A B),
                                              subgroup_colours: [nil, nil])
        hgb = add_member(group, "HGB", subgroup: 1)
        add_member(group, "PTH", subgroup: 2)
        login_as_super_admin

        visit edit_pathology_code_group_path(group)
        find("tr.membership",
             text: "HGB").find(".handle").drag_to(find("[data-subgroup='2'] tr.membership",
                                                       text: "PTH"))
        click_on t("btn.save")

        expect(hgb.reload.subgroup).to eq 2
      end
    end

    describe "deleting a code group" do
      it "deletes the group and its memberships" do
        group = create(:pathology_code_group, name: "Group1")
        create(:pathology_code_group_membership, code_group: group)
        login_as_super_admin

        visit edit_pathology_code_group_path(group)
        click_on "Delete code group"

        expect(CodeGroup.exists?(group.id)).to be false
        expect(CodeGroupMembership.count).to eq 0
      end

      it "cannot delete the default group" do
        group = create(:pathology_code_group, :default)
        login_as_super_admin

        visit edit_pathology_code_group_path(group)

        expect(page).to have_field("Name", disabled: true, with: "default")
        expect(page).to have_no_button "Delete code group"
        expect(page).to have_no_link "Delete code group"
      end
    end
  end
end

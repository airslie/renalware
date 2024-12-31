describe Renalware::HD::Sessions::WashbackQualityDialogComponent, type: :component do
  before do
    yaml = <<-YAML
      renalware:
        hd:
          sessions:
            washback_quality_dialog_component:
              title: Dialog title
              table:
                grade: Grade
                description: Description
      enumerize:
        renalware/hd/session_document/dialysis:
          washback_quality:
            '1': Name1
            '2': Name2
            '3': Name3
            '4': Name4
          washback_quality_description:
            '1': Desc1
            '2': Desc2
            '3': Desc3
            '4': Desc4
    YAML
    # Be sure to load the 'real' translations before overriding them with our
    # test ones using #store_translations
    I18n.t("enumerize.renalware/hd/session_document/dialysis")
    I18n.backend.store_translations(:en, YAML.safe_load(yaml))
  end

  describe "#table_data" do
    it "returns a hash combining washback quality names and descriptions" do
      expect(described_class.new.table_data).to eq(
        {
          "1": { name: "Name1", description: "Desc1" },
          "2": { name: "Name2", description: "Desc2" },
          "3": { name: "Name3", description: "Desc3" },
          "4": { name: "Name4", description: "Desc4" }
        }
      )
    end
  end

  it "render a table of quality grades with info pulled from I18n" do
    render_inline(described_class.new)

    expect(page).to have_content("Dialog title")
    expect(page).to have_content("Name1")
    expect(page).to have_content("Desc1")
    expect(page).to have_content("Name4")
    expect(page).to have_content("Desc4")
  end
end

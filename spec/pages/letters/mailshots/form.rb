require_relative "../../page_object"
require "capybara-select-2"

module Pages
  module Letters
    module Mailshots
      class Form < PageObject
        include CapybaraSelect2
        include TextEditorHelpers
        include SlimSelectHelper

        def navigate_here_from_admin_dashboard
          visit admin_dashboard_path

          within ".side-nav--admin" do
            click_on "Mailshots"
          end

          within ".page-actions" do
            click_on t("btn.add")
          end
        end

        def letterhead=(letterhead)
          select letterhead, from: "Letterhead"
        end

        def author=(user)
          slim_select user.to_s, from: "Author"
        end

        def description=(value)
          fill_in "Description", with: value
        end

        def sql_view_name=(value)
          select value, from: "Sql view name"
        end

        def body=(value)
          fill_trix_editor with: value
        end

        def patient_preview_table
          "#mailshot-patients-preview"
        end

        def submit
          accept_alert do
            click_on "Create letters"
          end
        end
      end
    end
  end
end

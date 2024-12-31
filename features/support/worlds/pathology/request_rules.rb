module World
  module Pathology
    module RequestForm
      module Domain
        # @section helpers
        #

        # @section commands
        #
        def view_request_algorithm_rules(_clinician)
          rule_sets = Renalware::Pathology::Requests::GlobalRuleSet.all

          Renalware::Pathology::Requests::GlobalRuleSetsTable.new(
            Renalware::Pathology::RequestDescription.all,
            Renalware::Clinics::Clinic.all,
            Renalware::Pathology::Requests::GlobalRuleSetPresenter.present(rule_sets)
          )
        end

        # @section expectations
        #
        def expect_rules_table_to_have_rule(rules_table, request_description, clinic)
          table_row = rules_table.rows.detect do |row|
            row.request_description == request_description
          end
          table_cell = table_row.columns.detect { |column| column.clinic == clinic }

          expect(table_cell.rule_sets.any?).to be_truthy
        end
      end

      module Web
        include Domain

        def view_request_algorithm_rules(clinician)
          login_as clinician

          visit pathology_requests_rules_path
        end

        def expect_rules_table_to_have_rule(_rules_table, request_description, clinic)
          xpath =
            "td[data-request='#{request_description.id}'][data-clinic='#{clinic.id}']"
          value_in_web = find(xpath).text

          expect(value_in_web.empty?).to be_falsey
        end
      end
    end
  end
end

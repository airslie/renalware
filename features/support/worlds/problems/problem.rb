module World
  module Problems::Problem
    module Domain
      # @section helpers
      #
      def problem_for(patient)
        patient.problems.last!
      end

      def seed_problem_for(patient, user)
        patient.problems.create(
          description: "outcome",
          created_by: user,
          notes: [
            Renalware::Problems::Note.new(description: "note", by: user)
          ]
        )
      end

      def create_problem(patient, params)
        patient.problems.create!(params)
      end

      # @section commands
      #
      def record_problem_for(patient:, user: nil)
        seed_problem_for(patient, user)
      end

      def revise_problem_for(patient:, user:, description:)
        problem = patient.problems.last!

        problem.update!(description: description)
      end

      def problem_drug_selector
        nil
      end

      def view_problems_list(patient, _clinician)
        current_problems = patient.problems.current
        archived_problems = patient.problems.archived

        [current_problems, archived_problems]
      end

      # @section expectations
      #
      def expect_problem_to_be_recorded(patient:, user:)
        problem = patient.problems.last

        expect(problem).to be_present
        expect(problem.created_by).to eq(user)
      end

      def expect_problem_revisions_to_be_recorded(patient:)
        problem = patient.problems.last!

        expect(problem.created_at).not_to eq(problem.updated_at)
      end

      def expect_problems_to_match_table(problems, table)
        table.hashes.each do |row|
          expect(problems.map(&:description)).to include(row[:description])
        end
      end
    end

    module Web
      include Domain

      # @section commands
      #
      def record_problem_for(patient:, user:)
        login_as user

        visit patient_problems_path(patient)
        click_on t("btn.add")

        within "#add-patient-problem-modal .modal" do
          # Close the search input on the pre-focussed select2 so our #select2 helper will work as
          # expected (it won't work if the select2 has focus, ie its search input is already open).
          find(:css, ".select2-selection").click

          select2 "major problem", from: "* Description", search: true
          click_on "Save"
        end

        expect(page).not_to have_css("#add-patient-problem-modal .modal") # dialog dismissed
        expect(page).to have_content("major problem") # problem added to page
      end

      def revise_problem_for(patient:, user:, description:)
        login_as user

        visit patient_problem_path(patient, problem_for(patient))
        click_on t("btn.edit")
        # actually now goes to #show

        select2 description, from: "* Description", search: true
        click_on "Save"
      end

      def view_problems_list(patient, clinician)
        login_as clinician

        visit patient_problems_path(patient)

        current_problems = html_table_to_array("current_problems").drop(1)
        archived_problems = html_table_to_array("archived_problems").drop(1)

        [current_problems, archived_problems]
      end

      # @section expectations
      #
      def expect_problems_to_match_table(problem_strings, table)
        problem_strings.zip(table.hashes).each do |problem_string, row|
          expect(problem_string).to include(row[:description])
        end
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

describe "Problems" do
  let(:patient) { create(:pathology_patient) }

  describe "GET show" do
    context "when viewing a current problem" do
      it "responds with the problem" do
        problem = create(:problem, patient: patient)

        get patient_problem_path(patient_id: patient, id: problem.id)

        expect(response).to be_successful
      end
    end

    context "when viewing an archived problem" do
      it "responds with the problem" do
        archived_problem = create(:problem, patient: patient, deleted_at: Date.current)

        get patient_problem_path(patient_id: patient, id: archived_problem.id)

        expect(response).to be_successful
      end
    end
  end

  describe "POST create" do
    describe "storing the problem date and its style correctly" do
      [
        { inputs: ["", "", "2011"], expected: { style: "y", date: Date.parse("01-01-2011") } },
        { inputs: ["", "6", "2011"], expected: { style: "my", date: Date.parse("01-06-2011") } },
        { inputs: %w(7 6 2011), expected: { style: "dmy", date: Date.parse("07-06-2011") } },
        { inputs: %w(31 02 2011), expected: { style: "dmy", date: Date.parse("03-03-2011") } },
        { inputs: ["", "", ""], expected: { style: nil, date: nil } }
      ].each do |hash|
        it do
          inputs = hash[:inputs]
          expected = hash[:expected]

          post patient_problems_path(
            patient_id: patient,
            params: {
              problems_problem: {
                "date(3i)" => inputs[0],
                "date(2i)" => inputs[1],
                "date(1i)" => inputs[2],
                description: "A problem",
                snomed_id: "123"
              }
            }
          )

          expect(response).to be_successful

          problem = patient.reload.problems.first
          expect(problem).to have_attributes(
            description: "A problem",
            snomed_id: "123",
            date_display_style: expected[:style],
            date: expected[:date]
          )
        end
      end
    end
  end
end

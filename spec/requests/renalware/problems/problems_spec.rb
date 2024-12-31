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

      it "updated positions correctly" do
        datetime = Time.zone.parse("2023-01-01 00:00:00")

        # Patient has 2 problems with positions 1 2. We will add new problem and it should have
        # position 3
        problems = create_list(:problem, 2, patient: patient)
        expect(problems.map(&:position)).to eq([1, 2])

        # Another patient has a problem with position 99. It should be unaffected.
        other_patient = create(:patient)
        other_patient_problem = create(:problem, patient: other_patient)
        other_patient_problem.update_column(:position, 99)
        other_patient_problem.update_column(:updated_at, datetime)
        expect(other_patient_problem.position).to eq(99)

        post patient_problems_path(
          patient_id: patient,
          params: {
            problems_problem: {
              "date(3i)" => "31",
              "date(2i)" => "02",
              "date(1i)" => "2011",
              description: "A problem",
              snomed_id: "12345"
            }
          }
        )

        expect(response).to be_successful

        expect(patient.reload.problems.count).to eq(3)
        expect(patient.problems.map(&:position)).to eq([1, 2, 3])
        expect(patient.problems.last.snomed_id).to eq("12345")

        # Check there are no side-effects for the other patient
        other_patient.reload
        other_patient_problem.reload
        expect(other_patient_problem.position).to eq(99) # unchanged
        expect(other_patient.problems.count).to eq(1) # unchanged
        expect(other_patient_problem.updated_at).to eq(datetime) # unchanged
      end
    end

    describe "DELETE destroy" do
      it "sets deleted_at on the problem and doesn't change problems belonging to other patients" do
        datetime = Time.zone.parse("2023-01-01 00:00:00")

        # Patient has 3 problems with positions 1 2 3.  We will delete the second problem.
        # it should change the position of problem 3 to be 2
        # Note the act of creation sets the position incrementally
        problems = create_list(:problem, 3, patient: patient)
        expect(problems.map(&:position)).to eq([1, 2, 3])

        # Another patient has a problem with position 99. It should be unaffected.
        other_patient = create(:patient)
        other_patient_problem = create(:problem, patient: other_patient)
        other_patient_problem.update_column(:position, 99)
        other_patient_problem.update_column(:updated_at, datetime)
        expect(other_patient_problem.position).to eq(99)

        # Deleting a problem 2 from the first patient
        delete patient_problem_path(patient_id: patient, id: problems[1].id)

        expect(response).to be_redirect # success

        # Reload test subjects
        patient.reload
        other_patient.reload
        other_patient_problem.reload
        problems.each(&:reload)

        # Check the first patient problems
        expect(patient.problems.count).to eq(2) # was 3
        expect(problems[0].position).to eq(1) # unchanged
        expect(problems[2].position).to eq(2) # was 3
        expect(problems[1].deleted_at).to be_present # soft-deleted

        # Check there are no side-effects for the other patient
        expect(other_patient_problem.position).to eq(99) # unchanged
        expect(other_patient.problems.count).to eq(1) # unchanged
        expect(other_patient_problem.updated_at).to eq(datetime) # unchanged
      end
    end

    describe "PUT sort" do
      it "sorts only problems for the current patient" do
        datetime = Time.zone.parse("2023-01-01 00:00:00")

        # Patient has 3 problems with positions 1 2 3.
        # We will sort so that the problem with position 3 goes to the top and the others are
        # pushed down ie
        #   [problem1, problem2, problem3] => [problem3, problem1,problem2]
        # Note the act of creation sets the position incrementally
        problems = create_list(:problem, 3, patient: patient)
        expect(problems.map(&:position)).to eq([1, 2, 3])
        new_problem_id_order = [problems[2].id, problems[0].id, problems[1].id]

        # Another patient has a problem with position 99. It should be unaffected.
        other_patient = create(:patient)
        other_patient_problem = create(:problem, patient: other_patient)
        other_patient_problem.update_column(:position, 99)
        other_patient_problem.update_column(:updated_at, datetime)
        expect(other_patient_problem.position).to eq(99)

        post sort_patient_problems_path(
          patient_id: patient,
          params: {
            "problems_problem" => new_problem_id_order
          }
        )

        expect(response).to be_successful

        sorted_problems = patient.problems.reload
        expect(sorted_problems.map(&:id)).to eq(new_problem_id_order)
        expect(sorted_problems.map(&:position)).to eq([1, 2, 3])

        # Check there are no side-effects for the other patient
        other_patient_problem.reload
        expect(other_patient_problem.position).to eq(99) # unchanged
        expect(other_patient_problem.updated_at).to eq(datetime) # unchanged
        expect(other_patient.problems.reload.count).to eq(1) # unchanged
      end
    end
  end
end

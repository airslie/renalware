require_relative "access_steps"

module Renalware
  module Accesses
    module AccessProcedureSteps
      include AccessSteps
      extend WebSteps

      step :seed_procedure, ":patient has a recorded access procedure"
      step :create_procedure, ":user records an access procedure for :patient"
      step :create_bad_procedure, ":user submits an erroneous access procedure"
      step :assert_procedure_exists, ":patient has a new access procedure"
      step :update_procedure, ":user can update access procedure for :patient"
      step :assert_procedure_not_exists, "the access procedure is not accepted"

      def seed_procedure(*, performed_by: user)
        attrs = FactoryBot.attributes_for(
          :access_procedure,
          type: FactoryBot.create(:access_type),
          by: user,
          performed_by: performed_by
        )
        accesses_patient.procedures.create(attrs)
      end
      alias create_procedure seed_procedure

      def create_bad_procedure(*args)
        seed_procedure(args, performed_by: nil)
      end

      def assert_procedure_exists(*)
        expect(accesses_patient.procedures.first).to be_present
      end

      def assert_procedure_not_exists(*)
        expect(accesses_patient.procedures.count).to eq(0)
      end

      def update_procedure(*)
        procedure = accesses_patient.procedures.first
        procedure.update!(first_used_on: 1.day.from_now, by: user)
      end

      web_steps do
        def create_procedure(*)
          access_type = FactoryBot.create(:access_type)
          insertion_technique = create(:catheter_insertion_technique)
          user = login_as_clinical

          po = Pages::Accesses::ProcedurePage.new(accesses_patient)
          po.visit_add
          po.performed_on = l(Time.zone.today)
          po.performed_by = user.to_s
          po.procedure_type = access_type.to_s
          po.side = "Right"
          po.catetheter_insertion_technique = insertion_technique.description
          po.save
        end

        def update_procedure(*)
          login_as_clinical
          po = Pages::Accesses::ProcedurePage.new(accesses_patient)
          po.visit_edit
          po.side = "Left"
          po.save

          expect(accesses_patient.procedures.first.side).to eq(:left)
        end
      end
    end
  end
end

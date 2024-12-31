require_relative "access_steps"
# The first module the Domain-level steps as well as shared steps and functions
# that will available in steps_for(:web) below when the @web tag is specified.
module Renalware
  module Accesses
    module AccessAssessmentSteps
      include AccessSteps
      extend WebSteps
      step :create_assessment, ":user records an access assessment for :patient"
      step :assert_assessment_exists, ":patient has a new access assessment"

      # Using a splat because we will be passed a user name and a patient name arguments,
      # but we don't need them because we have patient and user as attr_readers, so we throw them away.
      def create_assessment(*)
        attrs = FactoryBot.attributes_for(
          :access_assessment,
          type_id: FactoryBot.create(:access_type).id,
          by: user
        )
        accesses_patient.assessments.create!(attrs)
      end

      def assert_assessment_exists(*)
        expect(accesses_patient.assessments.first).to be_present
      end

      # Steps in here will only be included if the scenario is tagged as @web web_steps do
      web_steps do
        # Note that self.class in there is something like
        # RSpec
        #   ::ExampleGroups
        #   ::RecordingAnAccessAssessmentForAPatient (file name)
        #   ::AClinicianRecordedAnAccessAssessment (scenario name)
        # So the scope of member variables, and overwritten methods (ie including this module for @web
        # tags) is always within the scope of the scenario.
        def assert_assessment_exists(*)
          p "web version called"
          login_as_clinical
          visit dashboard_path
          # Do something with a Capybara page here, preferable with a page object
          expect(accesses_patient.assessments.first).to be_present
        end
      end
    end
    # If @web is specified in the the feature file for this scenario, we include these steps.
    # They will often override some methods defined earlier in AccessSteps.
    # In Cucumber World parlance, AccessSteps is the Domain world and steps_for(:web) defines
    # the Web world.
    # steps_for is a shortcut for defining a Web module - it does this
    # Module.new do
    #   singleton_class.send(:define_method, :tag) { tag }
    #   module_eval(&block)
    #   ::RSpec.configure { |c| c.include self, tag => true }
    # end
    #
    # If we wanted to use the old cucumber way we could do this
    # module AccessSteps
    #   module Web
    #     # ...
    #   end
    #
    #   RSpec.configure { |c| c.include Web, :web => true }
    # end
  end
end

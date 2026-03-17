module Renalware
  module Research
    describe StudyEventPolicy, type: :policy do
      include PolicySpecHelper

      subject(:policy) { described_class }

      permissions :edit?, :update? do
        it "inherits the event policy edit rules" do
          user = user_double_with_role(:super_admin)
          type = Events::Type.new(
            superadmin_can_always_change: true,
            admin_change_window_hours: 0,
            author_change_window_hours: 0
          )
          event = StudyEvent.new(event_type: type)

          is_expected.to permit(user, event)
        end
      end

      permissions :destroy? do
        it "inherits the event policy destroy rules" do
          user = user_double_with_role(:super_admin)
          type = Events::Type.new(save_pdf_to_electronic_public_register: true)
          event = StudyEvent.new(event_type: type)

          is_expected.to permit(user, event)
        end
      end
    end
  end
end

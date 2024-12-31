# rubocop:disable Layout/LineLength, Layout/ExtraSpacing
module Renalware
  module Events
    describe EventPolicy, type: :policy do
      include PolicySpecHelper

      subject(:policy) { described_class }

      %i(edit? update? destroy?).each do |permission|
        permissions permission do
          [
            { role: :super_admin, author: false, superadmin_can_always_change: true,  admin_change_window_hours: 0, author_change_window_hours: 0, expected: true  },
            { role: :super_admin, author: false, superadmin_can_always_change: false, admin_change_window_hours: 0, author_change_window_hours: 0, expected: false  },
            { role: :super_admin, author: true,  superadmin_can_always_change: true,  admin_change_window_hours: 0, author_change_window_hours: 0, expected: true  },
            { role: :admin,       author: false, superadmin_can_always_change: true,  admin_change_window_hours: 0, author_change_window_hours: 0, expected: false },
            { role: :admin,       author: true,  superadmin_can_always_change: true,  admin_change_window_hours: 0, author_change_window_hours: 0, expected: false },
            { role: :admin,       author: false, superadmin_can_always_change: true,  admin_change_window_hours: 1, author_change_window_hours: 0, expected: true  },
            { role: :super_admin, author: false, superadmin_can_always_change: false, admin_change_window_hours: 1, author_change_window_hours: 0, expected: true  },
            { role: :admin,       author: false, superadmin_can_always_change: true,  admin_change_window_hours: 1, author_change_window_hours: 0, created_at: 2.hours.ago, expected: false },
            { role: :admin,       author: true,  superadmin_can_always_change: true,  admin_change_window_hours: 0, author_change_window_hours: 1, expected: true  },
            { role: :admin,       author: true,  superadmin_can_always_change: true,  admin_change_window_hours: 0, author_change_window_hours: 1, created_at: 2.hours.ago, expected: false },
            { role: :clinician,   author: false, superadmin_can_always_change: true,  admin_change_window_hours: 0, author_change_window_hours: 1, expected: false  },
            { role: :clinician,   author: true,  superadmin_can_always_change: true,  admin_change_window_hours: 0, author_change_window_hours: 1, expected: true  },
            { role: :clinician,   author: true,  superadmin_can_always_change: true,  admin_change_window_hours: 0, author_change_window_hours: 1, created_at: 2.hours.ago, expected: false },
            { role: :clinician,   author: true,  superadmin_can_always_change: true,  admin_change_window_hours: 0, author_change_window_hours: 100, created_at: 99.hours.ago, expected: true },
            { role: :clinician,   author: true,  superadmin_can_always_change: true,  admin_change_window_hours: 0, author_change_window_hours: 100, created_at: 101.hours.ago, expected: false }
          ].each do |opts|
            context opts.to_s do
              it do
                user = user_double_with_role(opts.fetch(:role, :clinician))
                type = Events::Type.new(
                  superadmin_can_always_change: opts[:superadmin_can_always_change],
                  admin_change_window_hours: opts[:admin_change_window_hours],
                  author_change_window_hours: opts[:author_change_window_hours]
                )
                event = Event.new(
                  event_type: type,
                  created_at: opts.fetch(:created_at, Time.zone.now)
                )
                if opts[:author]
                  allow(event).to receive(:created_by).and_return(user)
                end

                if opts[:expected]
                  is_expected.to permit(user, event)
                else
                  is_expected.not_to permit(user, event)
                end
              end
            end
          end
        end
      end

      permissions :destroy? do
        it do
          user = user_double_with_role(:super_admin)
          type = Events::Type.new(save_pdf_to_electronic_public_register: true)
          event = Event.new(event_type: type)

          is_expected.to permit(user, event)
        end
      end
    end
  end
end
# rubocop:enable Layout/LineLength, Layout/ExtraSpacing

module Renalware
  describe Users::Groups::Membership do
    it :aggregate_failures do
      is_expected.to belong_to(:group).with_foreign_key(:user_group_id)
      is_expected.to belong_to(:user)
      is_expected.to validate_presence_of(:group)
      is_expected.to validate_presence_of(:user)
      is_expected.to have_db_index(%i(user_id user_group_id)).unique(true)
    end
  end
end

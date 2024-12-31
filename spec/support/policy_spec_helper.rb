module PolicySpecHelper
  def user_double_with_role(roles)
    roles = Array(roles)
    instance_double(Renalware::User).tap do |user|
      allow(user).to receive_messages(has_role?: false) # catch all for eg has_role?(:devops)
      allow(user).to receive_messages(roles: roles, role_names: roles.map(&:to_s))
      roles.each do |role|
        allow(user).to receive(:has_role?).with(role).and_return(true)
      end
    end
  end
end

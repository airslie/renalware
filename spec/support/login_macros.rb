module LoginMacros
  def login_as_super_admin
    login_user(:super_admin)
  end

  def login_as_admin
    login_user(:admin)
  end

  def login_as_clinical(*other_roles)
    login_user(:clinical, *other_roles)
  end

  def login_as_read_only
    login_user(:read_only)
  end

  def login_as_with_user(user, *other_roles)
    other_roles.each { |role| user.roles << create(:role, role) }

    if @request.present? # eg for controller specs
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    else # features
      login_as user
    end
    @current_user = user
  end

  def login_user(role_trait = :super_admin, *other_roles)
    user = create(:user, role_trait)
    other_roles.each { |role| user.roles << create(:role, role) }

    if @request.present? # eg for controller specs
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    else # features
      login_as user
    end
    @current_user = user
  end
end

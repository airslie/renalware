module RolesSpecHelper
  def define_roles
    Renalware::Role::ROLES.each do |name|
      Renalware::Role.find_or_create_by!(name: name)
    end
  end
end

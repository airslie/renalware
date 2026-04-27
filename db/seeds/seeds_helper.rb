module SeedsHelper
  def without_papertrail_versioning_for(klasses)
    Array(klasses).each do |klass|
      klass.paper_trail.disable if klass.paper_trail.respond_to?(:disable)
    end

    yield

    Array(klasses).each do |klass|
      klass.paper_trail.enable if klass.paper_trail.respond_to?(:enable)
    end
  end

  def create_seed_user(attributes)
    role_names = Array(attributes.delete(:role)) + Array(attributes.delete(:additional_roles))
    roles = role_names.compact.map { |name| Renalware::Role.find_by!(name: name) }

    user = Renalware::User.find_or_initialize_by(username: attributes.fetch(:username))
    user.assign_attributes(attributes)
    user.roles = user.roles.to_a | roles
    user.save!
    user
  end
end

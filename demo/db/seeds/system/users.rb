module Renalware
  Rails.benchmark "Adding Demo Site Users" do
    ensure_factory_bot_loaded

    sites = %w(Barts KCH Kent Lister)
    host_hospital_centre_id = Hospitals::Centre.where(host_site: true).order(:name).pluck(:id).first

    sites.each do |site|
      site_code = site.downcase

      # superadmin
      username = "super#{site_code}"
      FactoryBot.create(
        :user,
        :with_ldap_enabled,
        :find_or_create,
        username: username,
        given_name: site,
        family_name: "Superuser",
        email: "#{username}@#{site_code}.trust.uk",
        password: Renalware.config.demo_password,
        approved: true,
        signature: "#{site} Superuser",
        feature_flags: 4,
        professional_position: Faker::Job.position,
        hospital_centre_id: host_hospital_centre_id,
        role: :super_admin
      )

      # admin
      username = "#{site_code}admin"
      FactoryBot.create(
        :user,
        :with_ldap_enabled,
        :find_or_create,
        username: username,
        given_name: site,
        family_name: "Admin",
        email: "#{username}@#{site_code}.trust.uk",
        password: Renalware.config.demo_password,
        approved: true,
        signature: "Dr #{site} Admin, MRCP",
        professional_position: Faker::Job.position,
        hospital_centre_id: host_hospital_centre_id,
        role: :admin,
        additional_roles: [:hd_prescriber]
      )

      # clinician
      username = "#{site_code}doc"
      FactoryBot.create(
        :user,
        :with_ldap_enabled,
        :find_or_create,
        username: username,
        given_name: "Doctor",
        family_name: site,
        email: "#{username}@#{site_code}.trust.uk",
        password: Renalware.config.demo_password,
        approved: true,
        signature: "Dr #{site}",
        telephone: Faker::PhoneNumber.phone_number,
        professional_position: Faker::Job.position,
        hospital_centre_id: host_hospital_centre_id,
        role: :clinical,
        additional_roles: [:prescriber]
      )

      # nurse NB same role as doc
      username = "#{site_code}nurse"
      FactoryBot.create(
        :user,
        :with_ldap_enabled,
        :find_or_create,
        username: username,
        given_name: site,
        family_name: "Nurse",
        email: "#{username}@#{site_code}.trust.uk",
        password: Renalware.config.demo_password,
        approved: true,
        signature: "#{site} Nurse",
        professional_position: Faker::Job.position,
        hospital_centre_id: host_hospital_centre_id,
        role: :clinical
      )

      # guest i.e. readonly
      username = "#{site_code}guest"
      FactoryBot.create(
        :user,
        :with_ldap_enabled,
        :find_or_create,
        username: username,
        given_name: site,
        family_name: "Guest",
        email: "#{username}@#{site_code}.trust.uk",
        password: Renalware.config.demo_password,
        approved: true,
        signature: "#{site} Guest",
        professional_position: [Faker::Job.seniority, Faker::Job.position].compact.join(" "),
        hospital_centre_id: host_hospital_centre_id,
        role: :read_only
      )
    end

    # add rwdev superadmin
    username = "rwdev"
    FactoryBot.create(
      :user,
      :with_ldap_enabled,
      :find_or_create,
      username: username,
      given_name: "Renalware",
      family_name: "Developer",
      email: "renalware@airslie.com",
      password: Renalware.config.demo_password,
      approved: true,
      signature: "Renalware Developer",
      professional_position: Faker::Job.position,
      authentication_token: "eZ4sswrWAtbx6hgfiGn8",
      hospital_centre_id: host_hospital_centre_id,
      role: :devops
    )
  end
end

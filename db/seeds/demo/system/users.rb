module Renalware
  Rails.benchmark "Adding Demo Site Users" do
    sites = %w(Barts KCH Kent Lister)
    host_hospital_centre_id = Hospitals::Centre.where(host_site: true).order(:name).pick(:id)

    sites.each do |site|
      site_code = site.downcase

      # superadmin
      username = "super#{site_code}"
      create_seed_user(
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
      create_seed_user(
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
      create_seed_user(
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
      create_seed_user(
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
      create_seed_user(
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
    create_seed_user(
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

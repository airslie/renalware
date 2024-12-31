module Renalware
  Rails.benchmark "Adding Demo Site Users" do
    sites = %w(Barts KCH Kent Lister)
    host_hospital_centre_id = Hospitals::Centre.where(host_site: true).order(:name).pluck(:id).first

    sites.each do |site|
      site_code = site.downcase

      # superadmin
      username = "super#{site_code}"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = site
        u.family_name = "Superuser"
        u.email = "#{username}@#{site_code}.trust.uk"
        u.password = Renalware.config.demo_password
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :super_admin)]
        u.signature = "#{site} Superuser"
        u.feature_flags = 4
        u.professional_position = Faker::Job.position
        u.hospital_centre_id = host_hospital_centre_id
      end

      # admin
      username = "#{site_code}admin"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = site
        u.family_name = "Admin"
        u.email = "#{username}@#{site_code}.trust.uk"
        u.password = Renalware.config.demo_password
        u.approved = true
        u.roles = [
          Renalware::Role.find_by!(name: :admin),
          Renalware::Role.find_by!(name: :hd_prescriber)
        ]
        u.signature = "Dr #{site} Admin, MRCP"
        u.professional_position = Faker::Job.position
        u.hospital_centre_id = host_hospital_centre_id
      end

      # clinician
      username = "#{site_code}doc"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = "Doctor"
        u.family_name = site
        u.email = "#{username}@#{site_code}.trust.uk"
        u.password = Renalware.config.demo_password
        u.approved = true
        u.roles = [
          Renalware::Role.find_by!(name: :clinical),
          Renalware::Role.find_by!(name: :prescriber)
        ]
        u.signature = "Dr #{site}"
        u.telephone = Faker::PhoneNumber.phone_number
        u.professional_position = Faker::Job.position
        u.hospital_centre_id = host_hospital_centre_id
      end

      # nurse NB same role as doc
      username = "#{site_code}nurse"

      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = site
        u.family_name = "Nurse"
        u.email = "#{username}@#{site_code}.trust.uk"
        u.password = Renalware.config.demo_password
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :clinical)]
        u.signature = "#{site} Nurse"
        u.professional_position = Faker::Job.position
        u.hospital_centre_id = host_hospital_centre_id
      end

      # guest i.e. readonly
      username = "#{site_code}guest"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = site
        u.family_name = "Guest"
        u.email = "#{username}@#{site_code}.trust.uk"
        u.password = Renalware.config.demo_password
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :read_only)]
        u.signature = "#{site} Guest"
        u.professional_position = [Faker::Job.seniority, Faker::Job.position].compact.join(" ")
        u.hospital_centre_id = host_hospital_centre_id
      end
    end

    # add rwdev superadmin
    username = "rwdev"
    Renalware::User.find_or_create_by!(username: username) do |u|
      u.given_name = "Renalware"
      u.family_name = "Developer"
      u.email = "renalware@airslie.com"
      u.password = Renalware.config.demo_password
      u.approved = true
      u.roles = [Renalware::Role.find_by!(name: :devops)]
      u.signature = "Renalware Developer"
      u.professional_position = Faker::Job.position
      u.authentication_token = "eZ4sswrWAtbx6hgfiGn8"
      u.hospital_centre_id = host_hospital_centre_id
    end
  end
end

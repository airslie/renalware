require "devise"

module Renalware
  class User < ApplicationRecord
    include Deviseable
    include Personable
    include RansackAll

    has_many :roles_users, dependent: :destroy
    has_many :roles, through: :roles_users
    belongs_to :hospital_centre, class_name: "Renalware::Hospitals::Centre", optional: true

    validates :username, presence: true, uniqueness: true
    validates :given_name, presence: true
    validates :family_name, presence: true
    validate :approval_with_roles, on: :update
    validates :professional_position, presence: {
      on: :update,
      if: ->(user) { user.with_extended_validation }
    }
    validates :signature, presence: {
      on: :update,
      if: ->(user) { user.with_extended_validation }
    }

    # This maps to a PG enum
    enum :nursing_experience_level, {
      very_low: "very_low",
      low: "low",
      medium: "medium",
      high: "high",
      very_high: "very_high"
    }

    scope :unapproved, -> { where(approved: [nil, false]) }
    scope :expired, -> { where.not(expired_at: nil) }
    scope :never_used, -> { where(last_activity_at: nil).where(created_at: ...expire_after.ago) }
    scope :inactive, -> do
      where
        .not(last_activity_at: nil)
        .where(last_activity_at: ...expire_after.ago)
        .or(never_used)
    end
    scope :excludable, -> { unapproved.or(inactive).or(expired).or(hidden) }
    scope :author, -> { where.not(signature: nil) }
    scope :ordered, -> { visible.order(:family_name, :given_name) }
    scope :excluding_system_user, -> { where.not(username: SystemUser.username) }
    scope :consultants, -> { where(consultant: true).excluding_system_user.ordered }
    scope :visible, -> { where(hidden: false) }
    scope :hidden, -> { where(hidden: true) }
    scope :picklist, -> { visible.ordered }
    scope :active, -> do
      visible
        .where(last_activity_at: expire_after.ago...)
        .where.not(banned: true)
        .ordered
    end

    store_accessor :preferences, :experimental_features

    after_create :assign_default_role_if_needed

    # Non-persistent attribute to signify we want to use extended validation.
    # We need to refactor this by using a form object for updating a user.
    attr_accessor :with_extended_validation

    # Non-persistent attribute to signify we want to unlock access
    attr_accessor :access_unlock

    def self.policy_class = UserPolicy

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
    # Experimental - create or update a user from an Entra ID (Azure AD) OmniAuth hash
    def self.from_entra_id_omniauth(auth)
      # auth is OmniAuth::AuthHash
      uid  = auth.uid
      info = auth.info
      email = info.email&.downcase

      # Pick your own mapping rules here
      user = find_or_initialize_by(azure_uid: uid)

      if user.new_record?
        # Fallback: match on email if you already have users
        user = find_or_initialize_by(email: email) if email.present?
        user.azure_uid = uid
        # For username we want to use the sAMAccountName synced from on-prem AD.
        # eg sAMAccountName -> onPremisesSamAccountName in Entra.
        # Then we need to add a claim mapping in Entra ID app registration
        # to include this in the token.
        # or now use the uid directly.
        user.username ||= uid # change to sAMAccountName when available
        user.email ||= email
        user.family_name ||= info.last_name
        user.given_name  ||= info.first_name
        # Optionally set random password if you still need Devise validations:
        user.password ||= SecureRandom.hex(32)
        user.approved = Renalware.config.ldap_auto_approve_users
        user.hospital_centre = Renalware::Hospitals::Centre.site_default
      end

      sync_roles(user, auth.extra.raw_info["roles"])
      user.save! if user.changed?
      user
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    # Experimental - create or update a user from an Entra ID (Azure AD) OmniAuth hash
    def self.from_ldap_omniauth(auth, password)
      # auth is OmniAuth::AuthHash
      username = auth.uid
      info = auth.info
      email = info.email&.downcase

      # Pick your own mapping rules here
      user = find_or_initialize_by(username: username)

      if user.new_record?
        # Fallback: match on email if you already have users
        user = find_or_initialize_by(email: email) if email.present?
        # For username we want to use the sAMAccountName synced from on-prem AD.
        # eg sAMAccountName -> onPremisesSamAccountName in Entra.
        # Then we need to add a claim mapping in Entra ID app registration
        # to include this in the token.
        # or now use the uid directly.
        user.username ||= username
        user.email ||= email
        user.family_name ||= info.last_name
        user.given_name  ||= info.first_name

        # Optionally set random password if you still need Devise validations:
        user.password ||= password.presence || SecureRandom.hex(32)
        user.approved = Renalware.config.ldap_auto_approve_users
        user.hospital_centre = Renalware::Hospitals::Centre.site_default
      end

      sync_roles(user, auth.extra.raw_info["memberof"])

      user.save! if user.changed?
      user
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

    # Look up all roles in the database that have an ad_role_name, and sync them to the user.
    # Note roles are always downcased for matching.
    def self.sync_roles(user, ad_roles)
      # Normalize ad_roles to an array of downcased role names, removing any LDAP path info
      ad_roles = Array(ad_roles).map { |role| role.downcase.split(",").first.sub("cn=", "") }

      Role.where.not(ad_role_name: nil).find_each do |role|
        # If the user's AD roles include this role's ad_role_name, ensure the user has the role
        # Otherwise ensure the user does not have the role
        if ad_roles.include?(role.ad_role_name.downcase)
          user.roles << role unless user.roles.include?(role)
        else
          user.roles.delete(role) # user may not have the role but delete is safe
        end
      end
    end

    # So we can uses these scopes as Ransack predicates eg. { expired: true }
    def self.ransackable_scopes(_auth_object = nil)
      %i(unapproved inactive expired)
    end

    # Send devise emails using activejob
    def send_devise_notification(notification, *)
      devise_mailer.send(notification, self, *).deliver_later
    end

    def has_role?(name)
      role_names.include?(name.to_s)
    end

    def role_names
      @role_names ||= roles.pluck(:name)
    end

    # Official name for use when displaying e.g. on a letter. For example:
    #   Dr Isaac Newton (Consultant Gravitationalist)
    def professional_signature
      signed = signature || full_name
      signed += " (#{professional_position})" if professional_position?
      signed
    end

    def generate_new_authentication_token!
      build_authentication_token.tap do |token|
        update_column(:authentication_token, token)
      end
    end

    # Create a sha that can be saved in another model to indicate a user has authenticated
    # (or perhaps more correctly, authorised) an action - e.g. in HD Session form where a nurse
    # and witness both enter their credentials against a prescription administered on HD.
    # The idea is that we can check the token belongs to the user buy regenerating the token at any
    # time and checking it still matches. Unlike Devise.friendly_token, we can always regenerate
    # the same token here for any user as it is salted with the same secret. This secret is not
    # stored git for uat and production environments.
    def auth_token
      digest = OpenSSL::Digest.new("sha256")
      OpenSSL::HMAC.hexdigest(digest, Rails.application.secret_key_base, id.to_s)
    end

    # We can enable experiment features for particular users using the bitmask user#feature_flags
    # property and bitwise operators.
    # For example given the the feature flag FANCY_GRAPHS = 2, we if they user should see these with
    #   FANCY_GRAPHS & feature_flags == FANCY_GRAPHS
    def wants_feature?(flag)
      flag.allbits?(feature_flags)
    end

    private

    def build_authentication_token
      loop do
        token = ::Devise.friendly_token
        break token unless User.find_by(authentication_token: token)
      end
    end

    def approval_with_roles
      if approved? && roles.empty?
        errors.add(:approved, "approved users must have a role")
      end
    end

    def assign_default_role_if_needed
      return if roles.exists?

      default = if Renalware.config.ldap_authentication && Renalware.config.ldap_auto_approve_users
                  :read_only
                else
                  :clinical
                end

      begin
        roles << Role.find_by!(name: default)
      rescue ActiveRecord::RecordNotFound => e
        raise e unless Rails.env.test?
      end
    end
  end
end

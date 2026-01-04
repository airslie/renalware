module Renalware
  module HD
    class PrescriptionAdministration < ApplicationRecord
      include Accountable

      acts_as_paranoid

      has_paper_trail(
        versions: { class_name: "Renalware::HD::Version" },
        on: [:create, :update, :destroy]
      )

      # Set to true by the parent hd_session if we are not signing off at this stage
      attr_accessor(
        :skip_witness_validation,
        :skip_administrator_validation,
        :administered_by_password,
        :witnessed_by_password
      )

      belongs_to :hd_session, class_name: "HD::Session", touch: true
      belongs_to :prescription, class_name: "Medications::Prescription"
      belongs_to :administered_by, class_name: "User"
      belongs_to :witnessed_by, class_name: "User"
      belongs_to :reason, class_name: "PrescriptionAdministrationReason"
      validates :recorded_on, presence: true
      validates :administered, inclusion: { in: [true, false] }
      validates :prescription, presence: true
      validates :administered_by, presence: true, if: :validate_administrator?
      validates :witnessed_by, presence: true, if: :validate_witness?
      validate :check_administered_by_password, if: :validate_administrator?
      validate :check_witnessed_by_password, if: :validate_witness?
      validate :witness_cannot_be_administrator

      before_save :terminate_prescription_if_stat

      scope :ordered, -> { order(recorded_on: :desc, created_at: :desc) }
      scope :having_given_but_unwitnessed_prescriptions, lambda {
        # As the act of witnessing terminates the prescription, here, for safety, we are selecting
        # based on the prescription being unterminated, rather than witnessed = false.
        # This is a paranoid approach in case witnessing fails to terminate for any reason...
        where(administered: true)
          .joins(:prescription)
          .merge(
            Medications::Prescription
              .where(stat: true, administer_on_hd: true)
              .where.missing(:termination)
          )
      }

      def authorised?
        return true unless administered?

        signed_off_at.present?
      end

      def witnessed?
        administered? && authorised?
      end

      # stat means give one time only
      def terminate_prescription_if_stat
        if valid? &&
           witnessed? &&
           prescription.administer_on_hd? &&
           prescription.stat?

          if prescription.termination.nil?
            terminate_prescription(prescription)
          elsif prescription.termination.terminated_on > Time.zone.today
            update_existing_future_termination_to_terminate_immediately(prescription)
          end
        end
      end

      private

      def terminate_prescription(prescription)
        prescription.build_termination(
          terminated_on: Time.zone.now,
          notes: "Stat prescription automatically terminated once given",
          by: SystemUser.find
        ).save!
      end

      def update_existing_future_termination_to_terminate_immediately(prescription)
        termination = prescription.termination
        termination.terminated_on = Time.zone.today
        termination.created_by = termination.updated_by = SystemUser.find
        termination.save!
      end

      def witness_cannot_be_administrator
        return unless authorised?

        if administered_by_id.present? && administered_by_id == witnessed_by_id
          errors.add(:witnessed_by_id, "Must be a different user")
        end
      end

      def validate_witness?
        return false if not_administered?
        return false if skip_witness_validation
        return false unless Renalware.config.hd_session_prescriptions_require_signoff

        true
      end

      def validate_administrator?
        return false if not_administered?
        return false if skip_administrator_validation

        true
      end

      def not_administered?
        administered.nil? || administered == false
      end

      def check_administered_by_password # rubocop:disable Metrics/MethodLength
        return if administered_by.blank?

        self.administrator_authorised = false
        handle_ldap_error_for(:administered_by_password) do
          password_ok = Users::LdapRebind.verify_password!(
            username: administered_by.username,
            password: administered_by_password
          )

          if password_ok
            self.administrator_authorised = true
            set_signed_off_at_if_fully_authorised
          else
            errors.add(:administered_by_password, "Invalid password")
          end
        end
      end

      def check_witnessed_by_password # rubocop:disable Metrics/MethodLength
        return if witnessed_by.blank?

        handle_ldap_error_for(:witnessed_by_password) do
          self.witness_authorised = false
          password_ok = Users::LdapRebind.verify_password!(
            username: witnessed_by.username,
            password: witnessed_by_password
          )

          if password_ok
            self.witness_authorised = true
            set_signed_off_at_if_fully_authorised
          else
            errors.add(:witnessed_by_password, "Invalid password")
          end
        end
      end

      def set_signed_off_at_if_fully_authorised
        return unless administrator_authorised?
        return if skip_witness_validation

        if witness_required_by_configuration?
          self.signed_off_at = Time.current if witness_authorised?
        else
          self.signed_off_at = Time.current
        end
      end

      def witness_required_by_configuration?
        Renalware.config.hd_session_prescriptions_require_signoff
      end

      def handle_ldap_error_for(error_field)
        yield
      rescue Ldap::Error => e
        Rails.logger.error "LDAP error during password check: #{e.message}"
        errors.add(error_field, I18n.t("renalware.system.errors.ldap.service_unavailable"))
      end
    end
  end
end

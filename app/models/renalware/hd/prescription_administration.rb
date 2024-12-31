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

        administrator_authorised? && witness_authorised?
      end

      def witnessed?
        administered? && witness_authorised?
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

      def check_administered_by_password
        return if administered_by.blank?

        self.administrator_authorised = false
        if administered_by.valid_password?(administered_by_password)
          self.administrator_authorised = true
        else
          errors.add(:administered_by_password, "Invalid password")
        end
      end

      def check_witnessed_by_password
        return if witnessed_by.blank?

        self.witness_authorised = false
        if witnessed_by.valid_password?(witnessed_by_password)
          self.witness_authorised = true
        else
          errors.add(:witnessed_by_password, "Invalid password")
        end
      end
    end
  end
end

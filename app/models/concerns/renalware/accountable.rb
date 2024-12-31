module Renalware
  # Responsible for assigning a system user to the record when it is created
  # and updated.
  #
  # @example
  #
  #   clinic_visit = ClinicVisit.new(by: current_user)
  #   clinic_visit.save!
  #   clinic_visit.created_by == current_user # => true
  #   clinic_visit.updated_by == current_user # => true
  #
  module Accountable
    extend ActiveSupport::Concern

    included do
      belongs_to :created_by, class_name: "Renalware::User"
      belongs_to :updated_by, class_name: "Renalware::User"

      before_create :assign_creator
      before_update :assign_updater

      attr_accessor :by

      scope :with_created_by, -> { includes(:created_by) }
      scope :with_updated_by, -> { includes(:updated_by) }
    end

    def save_by!(user, validate: true)
      self.by = user
      save!(validate: validate)
    end

    def save_by(user, validate: true)
      self.by = user
      save(validate: validate)
    end

    def update_by(user, attrs)
      self.by = user
      update(attrs)
    end

    def first_or_create_by!(user)
      self.by = user
      first_or_create_by!
    end

    private

    def assign_creator
      self.created_by ||= by
      self.updated_by = created_by
    end

    def assign_updater
      return unless persisted?
      return if updated_by_id_changed?

      self.updated_by = by
    end
  end
end

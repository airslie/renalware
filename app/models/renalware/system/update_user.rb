module Renalware
  module System
    class UpdateUser
      attr_reader :delivery_method, :notifications, :notifier, :user

      def initialize(user)
        @user = user
        @notifier = Admin::UserMailer
        @notifications = []
        @delivery_method = :deliver_later
      end

      def call(params)
        update!(params) && notify!
      end

      private

      # rubocop:disable Metrics/AbcSize
      def update!(params)
        User.transaction do
          approve if can_approve?(params)
          unexpire if can_unexpire?(params)
          unlock_access if true?(params[:access_unlock])
          user.consultant = true?(params[:consultant])
          user.nursing_experience_level = params[:nursing_experience_level]
          user.hidden = true?(params[:hidden])
          # if params[:prescriber] # if not a superadmin, may not be submitted
          #   user.prescriber = true?(params[:prescriber])
          # end
          authorise(params)
          user.telephone = params[:telephone]
          user.hospital_centre_id = params[:hospital_centre_id]
          user.banned = params.fetch(:banned, false)
          user.notes = params[:notes]
          user.save!
        end
      rescue ActiveRecord::RecordInvalid
        false
      end
      # rubocop:enable Metrics/AbcSize

      def notify!
        notifications.each { |n| n.public_send(delivery_method) } if notifications.any?
        true
      end

      def can_approve?(params)
        params.key?(:approved) && true?(params[:approved]) && !user.approved?
      end

      def approve
        notifications << notifier.approval(user)
        user.approved = true
      end

      def can_unexpire?(params)
        true?(params[:unexpire]) && user.expired?
      end

      def unexpire
        notifications << notifier.unexpiry(user)
        user.expired_at = nil
        user.last_activity_at = Time.zone.now
      end

      def unlock_access
        user.locked_at = nil
        user.failed_attempts = 0
        user.unlock_token = nil
      end

      def authorise(params)
        user.roles = sanitized_roles(params)
      end

      def sanitized_roles(params)
        @sanitized_roles ||= begin
          roles = params[:roles] || []
          remove_hidden_roles(roles)
          preserve_super_admin_role_if_previously_set(roles)
        end
      end

      # Hidden roles e.g. superadmin cannot be set in the UI so remove if found
      def remove_hidden_roles(roles)
        roles.reject(&:hidden)
      end

      def preserve_super_admin_role_if_previously_set(roles)
        if user.has_role?(:super_admin)
          roles << Role.find_by(name: :super_admin)
        end
        roles
      end

      def true?(param)
        param == "true"
      end
    end
  end
end

# This demo letter listener had been wired to receive the letter* broadcast events in the
# broadcast_subscription_map (see config/initializers/renalware.rb) and it illustrates some
# actions that can be taken after the letter has been approved/deleted.
#
# Before Letter Approve (before_letter_approved event)
# ----------------------------------------------------
# No need to take action on this event but if we feel the letter should not be approved for
# any reason, we can raise an exception to cancel the 'approve letter' transaction we are inside
# during this event.
#
# Letter Approved (letter_approved event)
# ---------------------------------------
# Note we are outside the 'approve letter' transaction here, so even if we raise an error,
# the txn will not rollback.
#
# Its worth mentioning that you might like to defer some actions into the future, to allow
# a cooling off period, eg 2 hours, within which the letter can be revoked if it was decided an
# error was made. In these instances, we will need to store the ActiveJob.id of any future-scheduled
# jobs so we can find and try them if the letter is revoked within the period. If the period has
# elapsed and the job(s) have been processed, then a replacement letter will need to be sent.
# Somewhere in the UI we need to indicate that future jobs where or where not cancelled.
#
# Examples of things we could do here for #letter_approved
# - copy the letter in to folder for later submission to CRS
# - send the letter in a HL7 or FHIR message to the hospital TIE
# - send the letter in a FHIR message to Patient Knows Best
# - send the letter to the practice via the MESH API (eg with GPConnect 'Send Document' workflow)
# - email the letter to the practice
#
# Letter Deleted (letter_deleted event)
# -------------------------------------
# Examples of things we could do here for #letter_deleted
# - cancel pending MESH transmissions
# - log or audit something
# - email an admin
# - raise an error to cancel letter deletion
#
class LetterListener
  ###########################
  # Letter approval callbacks
  ###########################

  # Inside a txn so this callback is suitable for changing database records including ActiveJobs
  def before_letter_approved(letter); end

  # Txn has been committed here, so its suited to non-transactional tasks (not involving the db)
  def letter_approved(letter)
    # TODO: might need to switch this to the pre-commit #before_letter_approved ?
    if Renalware.config.send_gp_letters_over_mesh
      enqueue_a_scheduled_job_to_deliver_to_gp_over_mesh(letter)
    end
  end

  def rollback_letter_approved; end

  ###########################
  # Letter deletion callbacks
  ###########################

  # Inside a txn
  def before_letter_deleted(_letter)
    if Renalware.config.send_gp_letters_over_mesh
      Rails.logger.warn("not implemented yet: Transmission.cancel_pending(letter: letter)")
      # mesh::Transmission.cancel_pending(letter: letter)
    end
  end

  # Outside txn, after letter deleted
  def letter_deleted(letter); end
  def rollback_letter_deleted; end

  private

  def mesh = Renalware::Letters::Transports::Mesh

  def enqueue_a_scheduled_job_to_deliver_to_gp_over_mesh(letter)
    delay = Renalware.config.mesh_delay_seconds_between_letter_approval_and_mesh_send
    transmission = mesh::Transmission.create!(letter: letter)
    job = mesh::SendMessageJob.set(wait: delay).perform_later(transmission)
    transmission.update!(active_job_id: job.job_id) if job.respond_to?(:job_id)
  end

  def email_letter_to_practice(letter)
    # At KCH for example, we email the letter to the practice on approval, provided the practice
    # has an email address.
    # EmailLetterToPractice uses deliver_later so email delivery effectively asynchronous
    Renalware::Letters::Delivery::Email::EmailLetterToPractice.call(letter)
  end

  # This mechanism puts the letter into renalware.outgoing_documents and then Mirth polls this table
  # and sends the letter as e.g. an MDM HL7 message to the configured location - for example the
  # hospital TIE.
  def send_hl7_mdm_message_to_hospital_tie_via_mirth(letter)
    Renalware::Feeds::OutgoingDocument.create!(renderable: letter, by: letter.approved_by)
  end
end

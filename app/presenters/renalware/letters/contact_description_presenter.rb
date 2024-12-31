module Renalware
  module Letters
    class ContactDescriptionPresenter
      pattr_initialize :contact_description
      delegate_missing_to :contact_description

      def name
        ::I18n.t(system_code, scope: "renalware.letters.contacts.form.description", default: super)
      end
    end
  end
end

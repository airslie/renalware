require "liquid" # See https://github.com/Shopify/liquid

module Renalware
  module System
    class RenderLiquidTemplate
      def self.call(...)
        new.call(...)
      end

      # Takes the #body of a database-stored Template model, parses it with the Liquid gem to insert
      # variables, and return the resulting html.
      # Raises an exception id the template is not found or a variable the template requires was
      # not supplied.
      #
      # The body stored in the template#body could be any an html fragment or the whole page, but if
      # the latter if should be the inner html of the <body> tag and not contain a <body> tag itself
      # Any <style> tags (ie css) will have to be also inside the body, which works fine; there is
      # currently no support for rendering items the page <head> for instance. Any images must be
      # embedded as binary data.
      #
      # This approach allows us to render hospital-defined content in a small number of places -
      # for Barts can print an ESI as a PDF form (eg at patients/xxx/pd/peritonitis_episodes/1.pdf)
      # to let them capture extra detail manually. Using this class lets us search for and load a
      # hospital-defined template to use in an instance as this. It reduces support overhead as
      # the templates table can be updated manually (by someone qualified); for example a designer
      # could make changes to the content and his work (html content with css in a style section as
      # described above) updated in the database.
      #
      # The one caveat is the insertion of variables. These have to be passed in the `variables`
      # argument which is a hash of Liquid::Drop instances (see for example PatientDrop) - this is
      # just a safe read-only decorator around the data you want to use in a template (for
      # example "<h1>{{ patient.name }}</h1>")
      # See https://github.com/Shopify/liquid/wiki/Introduction-to-Drops
      #
      # Note this template approach is for adhoc hospital-defined content only as a means to add
      # customisation in certain edge cases, and should not be leaned on in preference to the
      # conventional rendering of actions/views explicitly, otherwise mayhem will result ;0)
      #
      # Example usage:
      #
      #   RenderLiquidTemplate.call("name_of_my_template",
      #                             patient: PatientDrop.new(patient),
      #                             prescriptions: PrescriptionsDrop.new(patient)
      #
      def call(template_name:, variables: nil)
        liquify_template(template_name, variables)
      end

      private

      def liquify_template(template_name, variables = {})
        Liquid::Template.error_mode = :strict
        template = Template.find_by!(name: template_name)
        liquified_template = Liquid::Template.parse(template.body)
        liquified_template.render!(variables, strict_variables: true)
      end
    end
  end
end

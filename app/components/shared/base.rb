# frozen_string_literal: true

# All components should inherit from this class or one of its subclasses
# (e.g. Shared::Form).
# It provides a few helpers and a default set of attributes.
# When initializing a component, if the content to be passed in is obvious for
# that component, you can pass it in directly. Otherwise, use keyword arguments.
# It's also better to yield content to allow for more flexibility, unless the
# component needs to manipulate the content itself.
# Pass unhandled attributes via the super initializer and they will be available
# in the attrs reader.

class Shared::Base < Phlex::HTML
  include Phlex::Rails::Helpers::Routes
  include Rails.application.routes.url_helpers # paths without `renalware.` prefix
  include Phlex::Rails::Helpers::AssetPath

  attr_reader :attrs

  def initialize(**user_attrs)
    @debug = user_attrs.delete(:debug)
    @debug = Rails.env.development? if @debug.nil?
    @attrs = mix(default_attrs, user_attrs)
    super()
  end

  if ENV["PHLEX_DEBUG_COMMENTS"]
    def before_template
      return unless @debug

      comment { "Before #{self.class.name}" }
      super
    end
  end

  private

  def default_attrs = {}

  # FIXME: Copied from AttributeNameHelper
  def attr_name(model, attr, suffix: ":")
    klass = model.is_a?(Class) ? model : model.class
    klass.human_attribute_name(attr) + String(suffix)
  end
end

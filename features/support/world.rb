# frozen_string_literal: true

# rubocop:disable Style/GlobalVars
Dir[Renalware::Engine.root.join("features/support/worlds/*.rb")].each { |f| require f }

$world_methods = []

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
def add_class_to_world(klass_name)
  exclusions = ENV["TEST_DEPTH"] == "web" ? [:Domain] : [:Web]

  klass = klass_name.constantize

  # Add klass to World
  klass_methods = klass.instance_methods
  join = $world_methods & klass_methods
  if join.present?
    puts "ERROR: these methods from #{klass} are defined in more than one world:"
    puts join
    exit 1
  else
    $world_methods += klass_methods
    World(klass)
  end

  # Only inject the world type we want
  constants = klass.constants - exclusions
  constants.each do |constant|
    add_class_to_world("#{klass.name}::#{constant}")
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize

add_class_to_world("World")

require_relative "../../lib/test_support/ajax_helpers"
World(AjaxHelpers)

require_relative "../../lib/test_support/text_editor_helpers"
World(TextEditorHelpers)
# rubocop:enable Style/GlobalVars

World(CapybaraSelect2)

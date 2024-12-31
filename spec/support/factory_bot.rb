RSpec.configure do |config|
  FactoryBot.use_parent_strategy = false
  FactoryBot.definition_file_paths = Array(Renalware::Engine.root.join("spec", "factories"))
  config.include FactoryBot::Syntax::Methods

  config.before(:all) do
    if FactoryBot.factories.count == 0
      # warn "Loading FactoryBot factories"
      FactoryBot.find_definitions
    end
  end

  Notifications = ActiveSupport::Notifications

  # For specs marked as monitor_database_record_creation: true, output each factory invocation
  # - useful when writing tests to check on excessive factory use.
  config.before(:each, :monitor_database_record_creation) do |_example|
    Notifications.subscribe("factory_bot.run_factory") do |_name, _start, _finish, _id, payload|
      warn "FactoryBot: #{payload[:strategy]}(:#{payload[:name]})"
    end
  end

  if ENV["REPORT_SLOW_FACTORIES"].present?
    # Capture the count of each FactoryBot factory.create() and sort them by number of invocations.
    # Output this at the end of the suite so we can keep an eye on escalating factory usage.
    factory_bot_results = {}
    config.before(:suite) do
      Notifications.subscribe("factory_bot.run_factory") do |_name, start, finish, _id, payload|
        factory_name = payload[:name]
        strategy_name = payload[:strategy]
        factory_bot_results[factory_name] ||= {}
        factory_bot_results[factory_name][strategy_name] ||= 0
        factory_bot_results[factory_name][strategy_name] += 1

        execution_time_in_seconds = finish - start

        if execution_time_in_seconds >= 0.5
          warn "Slow factory: #{payload[:name]} using strategy #{payload[:strategy]}"
        end
      end
    end

    # rubocop:disable Style/HashTransformValues
    config.after(:suite) do
      results = factory_bot_results
        .to_a
        .each_with_object({}) { |(key, val), hash| hash[key] = val[:create] }
        .sort { |a, b| (b.flatten.last || 0) <=> (a.flatten.last || 0) }
      warn "FactoryBot creates: #{results}"
    end
    # rubocop:enable Style/HashTransformValues
  end
end

# Use this strategy to get Hash output from factories defined using class: OpenStruct.
# Useful for working with jsonb-based Document objects.
#
# Example usage
#
#  factory :some_document, class: OpenStruct do
#    pulse 37
#  end
#
#  factory :something do
#   document factory: :some_document, strategy: :marshal_dump
#  end
#
class MarshalDumpStrategy
  def initialize
    @strategy = FactoryBot.strategy_by_name(:create).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    @strategy.result(evaluation).marshal_dump
  end
end
FactoryBot.register_strategy(:marshal_dump, MarshalDumpStrategy)

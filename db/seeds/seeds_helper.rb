module SeedsHelper
  def without_papertrail_versioning_for(klasses)
    Array(klasses).each do |klass|
      klass.paper_trail.disable if klass.paper_trail.respond_to?(:disable)
    end

    yield

    Array(klasses).each do |klass|
      klass.paper_trail.enable if klass.paper_trail.respond_to?(:enable)
    end
  end

  def ensure_factory_bot_loaded
    require "factory_bot_rails"
    require "faker"
    return if FactoryBot.factories.any?

    FactoryBot.definition_file_paths = Array(Renalware::Engine.root.join("spec", "factories"))
    FactoryBot.find_definitions
  end
end

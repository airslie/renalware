module ExceptionNotification
  class NotifierFactory
    def initialize(filename: nil, environment: nil)
      @filename = filename || Rails.root.join("config/exception_notification.yml")
      @environment = environment || Rails.env
    end

    attr_reader :filename, :environment

    def make
      notifier = configuration.fetch(:notifier)
      "::ExceptionNotification::Notifier::#{notifier.camelize}".constantize.new
    end

    def configuration
      @configuration ||= YAML.load_file(filename).fetch(environment).symbolize_keys!
    end
  end
end

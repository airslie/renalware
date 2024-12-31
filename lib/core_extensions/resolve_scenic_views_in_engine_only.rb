# Override Scenic's definition#full_path so it will resolve db/views as whatever is in
# config.paths["db/views"] if present, otherwise default to the original implementation.
# Note his does not support having or merging views in both engine and the host app (as yet).
module CoreExtensions
  module ResolveScenicViewsInEngineOnly
    def full_path
      app = Rails.application
      if defined?(app) && app && app.config.paths["db/views"].present?
        File.join(app.config.paths["db/views"].to_a.first, filename)
      else
        super
      end
    end
  end
end

Scenic::Definition.prepend(CoreExtensions::ResolveScenicViewsInEngineOnly)

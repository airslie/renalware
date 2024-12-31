module ApplicationHelper
  # Can search for named routes directly in the main app, omitting
  # the "main_app." prefix
  def method_missing(method, *, &)
    if main_app_url_helper?(method)
      main_app.send(method, *)
    else
      super
    end
  end

  def respond_to?(method, include_private_methods = false)
    main_app_url_helper?(method) || super
  end

  private

  def main_app_url_helper?(method)
    method.to_s.end_with?("_path", "_url") &&
      main_app.respond_to?(method)
  end
end

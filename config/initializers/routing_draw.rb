# Adds draw method into Rails routing.
# It allows us to keep routes split into files, one per module.
class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Renalware::Engine.root.join("config/routes/#{routes_name}.rb")))
  end
end

# Load the packaged feature engines under /packs so their routes and initializers are available.
# Use plain file paths so this works before Rails.root is set.
packs_root = File.expand_path("../../packs", __dir__)
Dir[File.join(packs_root, "*/lib/**/engine.rb")].each { |f| require f }

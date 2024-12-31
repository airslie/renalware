require "csv"
require_relative "seeds/seeds_helper"

PaperTrail.enabled = false

# TODO: Move this
include SeedsHelper # rubocop:disable Style/MixinUsage

# Seed the database with data common to all installations.
# Site specific data should be seeded from the host application.
require_relative "seeds/default/seeds"

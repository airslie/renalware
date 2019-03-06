# frozen_string_literal: true

require "engineer/database/seed_helper"

module Renalware
  extend Engineer::Database::SeedHelper

  ms = Benchmark.ms do
    # Load default seeds
    Renalware::Engine.load_seed

    Renalware.log_section "Seeding demo renalware-core data"
    require_relative "./seeds/seeds.rb"
  end

  log_section "Database seeding completed in #{ms / 1000}s"
end
SHOULDA_NOISE      = %w(shoulda).freeze
FACTORY_GIRL_NOISE = %w(factory_bot).freeze
RENALWARE_NOISE = SHOULDA_NOISE + FACTORY_GIRL_NOISE

Rails.backtrace_cleaner.add_silencer do |line|
  RENALWARE_NOISE.any? { |dir| line.include?(dir) }
end

# When debugging, uncomment the next line.
# Rails.backtrace_cleaner.remove_silencers!

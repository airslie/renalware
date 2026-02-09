# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

unless Rails.env.local?
  puts(<<-'ASC')
    ____                  _
   |  _ \ ___ _ __   __ _| |_      ____ _ _ __ ___
   | |_) / _ \ '_ \ / _` | \ \ /\ / / _` | '__/ _ \
   |  _ <  __/ | | | (_| | |\ V  V / (_| | | |  __/
   |_| \_\___|_| |_|\__,_|_| \_/\_/ \__,_|_|  \___|

  ASC
end

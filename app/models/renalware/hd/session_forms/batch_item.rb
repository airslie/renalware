module Renalware
  module HD
    module SessionForms
      class BatchItem < ApplicationRecord
        belongs_to :batch, counter_cache: true
        enum :status, { queued: 0, compiled: 10 }
      end
    end
  end
end

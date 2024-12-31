module SeedsHelper
  def without_papertrail_versioning_for(klasses)
    Array(klasses).each do |klass|
      klass.paper_trail.disable if klass.paper_trail.respond_to?(:disable)
    end

    yield

    Array(klasses).each do |klass|
      klass.paper_trail.enable if klass.paper_trail.respond_to?(:enable)
    end
  end
end

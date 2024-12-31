class CollectionPresenter
  # Initialises an enumerable collection of initialised presenters for the
  # corresponding original_collection of objects, for example a collection
  # of Letter objects.
  #
  # The *options catches:
  # - presenter_class, optional
  # - view_context, optional
  #
  # It is written this way because I needed to add an optional view_context
  # (which some Presenters may need) without breaking existing usage.
  def initialize(original_collection, *options)
    @original_collection = original_collection
    presenter_class, view_context = parse_options(options, block_given?)

    @decorated_collection ||= Enumerator.new do |yielder|
      original_collection.each do |element|
        presenter = if block_given?
                      yield(element)
                    else
                      build_presenter(presenter_class, element, view_context)
                    end
        yielder.yield(presenter)
      end
    end
  end

  delegate :_reflect_on_association, to: :presenter_class

  def to_ary
    @decorated_collection.to_a
  end

  def to_a
    @decorated_collection.to_a
  end

  delegate :size, to: :to_ary

  def to_json(*_args)
    @decorated_collection.map(&:to_hash).to_json
  end

  def method_missing(method, *, &)
    if @decorated_collection.respond_to?(method)
      @decorated_collection.public_send(method, *, &)
    else
      @original_collection.public_send(method, *, &)
    end
  end

  def respond_to_missing?(method, _unused = nil)
    @decorated_collection.respond_to?(method)
  end

  def respond_to?(method, _unused = nil)
    @decorated_collection.respond_to?(method) || @original_collection.respond_to?(method)
  end

  private

  def parse_options(options, block_given)
    options = Array(options)
    if options.empty? && !block_given
      raise "A presenter class must be supplied if no block given"
    end

    presenter_class = options[0]
    view_context = options[1]
    [presenter_class, view_context]
  end

  def build_presenter(klass, element, view_context)
    args = [element]
    args << view_context if view_context.present?
    klass.new(*args)
  end
end

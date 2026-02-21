# frozen_string_literal: true

class Forms::Homecare::Pdf
  def self.valid?(args)
    new(args).valid?
  end

  def self.generate(args)
    new(args).generate
  end

  def initialize(args)
    raise ArgumentError unless args

    @args = args
  end

  def valid?
    args.valid?
    check_args_are_able_to_create_a_pdf
    args.errors.none?
  end

  # Given an Args instance containing a provider (eg :fresenius) and a version (eg 1),
  # get the document class for e.g. Forms::Fresenius::Homecare::Document
  # and use it to build a new PDF with the data (patient name etc supplied in args)
  def generate
    document_klass = Forms.const_get(document_class_name)
    document_klass.build(args)
  rescue NameError => e
    raise(
      ArgumentError,
      "No PDF forms found for provider=#{args.provider} version=#{args.version} " \
      "trying to resolve Forms::#{document_class_name} " \
      "#{e.message}"
    )
  end

  private

  attr_reader :args

  def check_args_are_able_to_create_a_pdf
    unless Forms.const_defined?(document_class_name)
      args.errors.add(
        :base,
        "Supplied Provider and Version cannot be resolved to any homecare form"
      )
    end
  end

  def document_class_name
    return @document_class_name if @document_class_name

    provider = args.provider.to_s.capitalize
    "#{provider}::Homecare::Document"
  end
end

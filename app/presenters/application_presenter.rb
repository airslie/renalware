# From https://gist.github.com/nikhgupta/4107b8609d8786cd8839d7aa3455454c
#
class ApplicationPresenter
  attr_reader :model

  delegate_missing_to :@model
  delegate :helpers, to: "ActionController::Base"
  delegate :url_helpers, to: "Rails.application.routes"
  delegate :to_param, :to_json, :to_query, :to_yaml, :to_enum, to: :@model
  delegate :model_name, :model_name_const, :model_name_underscore, to: :class

  def initialize(model)
    @model = model
    instance_variable_set(:"@#{model_name_underscore.tr('/', '_')}", model)

    class_eval do
      attr_reader model_name_underscore.tr("/", "_")
    end
  end

  def decorated?
    true
  end

  class << self
    delegate :helpers, to: "ActionController::Base"
    delegate :all, :arel_table, :find_by_sql, :columns, :connection,
             :unscoped, :table_name, :primary_key, to: :model_name_const

    def model_name_const
      name = self.name || superclass.name
      name.delete_suffix("Presenter").constantize
    end

    def model_name_underscore
      model_name_const.to_s.underscore
    end

    def model_name
      ActiveModel::Name.new model_name_const.to_s.constantize
    end

    def build_default_scope
      model_name_const.send(:build_default_scope)
    end

    def decorate(*args)
      collection_or_object = args[0]
      if collection_or_object.respond_to?(:to_ary)
        DecoratedEnumerableProxy.new(collection_or_object, model_name_const)
      else
        new(collection_or_object)
      end
    end
  end

  class DecoratedEnumerableProxy < DelegateClass(ActiveRecord::Relation)
    include Enumerable

    delegate :as_json, :collect, :map, :each, :[], :all?, :include?,
             :first, :last, :shift, to: :decorated_collection

    def initialize(collection, class_name)
      super(collection)
      @class_name = class_name
    end

    def klass
      "#{@class_name}Presenter".constantize
    end

    def wrapped_collection
      __getobj__
    end

    def decorated_collection
      @decorated_collection ||= wrapped_collection.collect { |member| klass.decorate(member) }
    end
    alias to_ary decorated_collection

    def each(&)
      to_ary.each(&)
    end
  end
end

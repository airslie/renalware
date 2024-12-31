module Presenter
  def self.for(value)
    klass = "#{value.class.name}Presenter".constantize
    klass.send(:new, value)
  rescue NameError
    value.to_s
  end
end

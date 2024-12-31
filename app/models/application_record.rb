class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.decorate
    "#{name}Presenter".constantize.decorate(self)
  end

  def decorate
    "#{self.class.name}Presenter".constantize.decorate(self)
  end
end

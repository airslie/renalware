class Clinic < ActiveRecord::Base
  belongs_to :patient

  validates_presence_of :date
  validates_presence_of :height
  validates_presence_of :weight
  validates_presence_of :systolic_bp
  validates_presence_of :diastolic_bp

  def bmi
    ((weight / height) / height).round(2)
  end

  def bp
    "#{systolic_bp}/#{diastolic_bp}" if systolic_bp.present? && diastolic_bp.present?
  end

  def bp=(val)
    self.systolic_bp, self.diastolic_bp = val.split('/')
  end
end

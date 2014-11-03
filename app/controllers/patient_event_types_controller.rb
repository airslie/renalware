class PatientEventTypesController < ApplicationController

  def new
    @patient_event_type = PatientEventType.new
  end

  def create
    @patient_event_type = PatientEventType.new(allowed_params)
    if @patient_event_type.save
      redirect_to patient_event_types_path, :notice => "You have successfully added a new patient event type."
    else
      render :new
    end
  end

  def index
    @patient_event_types = PatientEventType.all
  end

  def allowed_params
    params.require(:patient_event_type).permit(:name)
  end 

end

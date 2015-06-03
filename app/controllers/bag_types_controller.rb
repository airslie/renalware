class BagTypesController < ApplicationController

  def new
    @bag_type = BagType.new
  end

  def create
    @bag_type = BagType.new(bag_type_params)
    if @bag_type.save
      redirect_to bag_types_path, :notice => "You have successfully created a new bag type."
    else
      render :new
    end
  end

  def index
    @bag_types = BagType.all
  end

  private
  def bag_type_params
    params.require(:bag_type).permit(:manufacturer, :description, :amount_1_36_glucose, :amount_2_27_glucose,
      :amount_3_86_glucose, :amount_amino_acid, :amount_icodextrin_acid, :uses_low_gdp, :uses_low_sodium)
  end
end

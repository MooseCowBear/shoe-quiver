class ShoesController < ApplicationController
  before_action :set_shoe, only: [:show, :edit, :update, :destroy]
  before_action :confirm_ownership, only: [:show, :edit, :update, :destroy]

  def new
    @shoe = Shoe.new
  end

  def create
    @shoe = Shoe.new(processed_shoe_params.except(:retire_at_units))
    @shoe.user = current_user

    puts "the new shoe is:"
    pp @shoe

    if @shoe.save
      redirect_to @shoe #will change
      flash[:notice] = "New shoe successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @shoe.update(processed_shoe_params.except(:retire_at_units))
      redirect_to @shoe #will change
      flash[:notice] = "Shoe successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
  end

  def destroy
    @shoe.destroy

    flash[:notice] = "Shoe was successfully deleted."
    redirect_to shoes_path
  end

  def index
    @shoes = current_user.shoes.current
  end

  def show
  end

  private

  def shoe_params
    params.require(:shoe).permit(:brand, :model, :color, :category, :retire_at, :retire_at_units)
  end

  def processed_shoe_params
    processed_params = shoe_params.deep_dup
    if (shoe_params[:retire_at_units] == "km")
      retire_at_mileage = km_to_miles(shoe_params[:retire_at]).round
      processed_params = processed_params.merge(retire_at: retire_at_mileage)
    end
    processed_params = processed_params.merge(category: shoe_params[:category].to_i)
  end

  def set_shoe 
    @shoe = Shoe.find(params[:id])
  end

  # will need to do this for runs too, so will move to application controller
  def confirm_ownership
    unless @shoe.user == current_user
      flash[:alert] = "Only a shoe's owner may view or modify it."
      redirect_to root_path
    end
  end
end

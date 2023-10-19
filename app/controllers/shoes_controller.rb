class ShoesController < ApplicationController
  before_action :set_shoe, only: [:show, :edit, :update, :destroy]

  before_action only: [:show, :edit, :update, :destroy] do
    confirm_ownership(@shoe, "Only the owner of a shoe may view or modify it.")
  end

  def new
    @shoe = Shoe.new
  end

  def create
    @shoe = Shoe.new(processed_shoe_params.except(:retire_at_units))
    @shoe.user = current_user

    if @shoe.save
      respond_to do |format|
        format.html { redirect_to @shoe, notice: "New shoe successfully added." }
        format.turbo_stream { flash.now[:notice] = "New shoe successfully added." } 
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @shoe.update(processed_shoe_params.except(:retire_at_units))
      respond_to do |format|
        format.html { redirect_to @shoe, notice: "Shoe successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Shoe successfully updated." } 
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
  end

  # keep?
  def destroy
    @shoe.destroy

    flash[:notice] = "Shoe was successfully deleted."
    redirect_to shoes_path
  end

  def index
    if params[:category]
      @shoes = current_user
        .shoes
        .current
        .where(category: params[:category].to_i)
        .order_by_last_run
        .order_by_creation
    else
      @shoes = current_user.shoes.current.order_by_last_run.order_by_creation
    end
  end

  def show
    @pagy, @runs = pagy(@shoe.runs.reverse_order_by_date, items: 10)
  end

  private

  def shoe_params
    params.require(:shoe)
      .permit(:brand, :model, :color, :category, :retire_at, :retire_at_units)
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
end

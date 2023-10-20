class ShoesController < ApplicationController
  before_action :set_shoe, only: [:show, :edit, :update, :destroy]

  before_action only: [:show, :edit, :update, :destroy] do
    confirm_ownership(@shoe, "Only the owner of a shoe may view or modify it.")
  end

  def new
    @shoe = Shoe.new
  end

  def create
    @shoe = Shoe.new(Shoe.process_params(shoe_params))
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
    if @shoe.update(Shoe.process_params(shoe_params))
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

  def destroy
    @shoe.destroy

    if request.referrer == shoe_url(@shoe)
      flash[:notice] = "Shoe was successfully deleted."
      redirect_to root_path
    else
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Shoe was successfully deleted." }
        format.turbo_stream { flash[:now] = "Shoe was successfully deleted." }
      end
    end
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

  def set_shoe 
    @shoe = Shoe.find(params[:id])
  end
end

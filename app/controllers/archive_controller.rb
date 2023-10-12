class ArchiveController < ApplicationController
  before_action :set_shoe, only: [:update, :destroy]

  before_action only: [:update, :destroy] do
    confirm_ownership(@shoe, "Only the owner of a shoe may modify it.")
  end

  def index
    if params[:category]
      @pagy, @shoes = pagy(current_user
        .shoes
        .archived
        .where(category: params[:category].to_i)
        .order_by_retirement, items: 10)
    else
      @pagy, @shoes = pagy(current_user.shoes.archived.order_by_retirement, items: 10)
    end
  end

  def update
    # retiring a shoe
    @shoe.update(retired_on: DateTime.now)
    redirect_to archive_index_path 
  end

  def destroy
    # un-retiring a shoe
    @shoe.update(retired_on: nil)
    redirect_to root_path 
  end

  private 

  def set_shoe
    @shoe = Shoe.find(params[:id])
  end
end

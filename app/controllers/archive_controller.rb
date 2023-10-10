class ArchiveController < ApplicationController
  # TODO: move confirm_ownership to application controller and check here before update and destroy
  before_action :set_shoe, only: [:update, :destroy]

  def index
    if params[:category]
      @shoes = current_user
        .shoes
        .archived
        .where(category: params[:category].to_i)
        .order_by_retirement
    else
      @shoes = current_user.shoes.archived.order_by_retirement
    end
  end

  def update
    # retiring a shoe
    @shoe.update(retired_on: DateTime.now)
    redirect_to archive_index_path #not right...
  end

  def destroy
    # un-retiring a shoe
    @shoe.update(retired_on: nil)
    redirect_to root_path #not right...
  end

  private 

  def set_shoe
    @shoe = Shoe.find(params[:id])
  end
end

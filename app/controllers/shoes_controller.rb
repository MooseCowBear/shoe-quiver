class ShoesController < ApplicationController
  def new
  end

  def create
  end

  def update
  end

  def edit
  end

  def destroy
  end

  def index
    @shoes = current_user.shoes.current
  end

  def show
  end
end

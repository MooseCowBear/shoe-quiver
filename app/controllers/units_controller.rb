class UnitsController < ApplicationController
  def update
    current_user.update(unit_params)
    redirect_back_or_to '/', allow_other_host: false
  end

  private

  def unit_params
    params.require(:user).permit(:unit)
  end
end

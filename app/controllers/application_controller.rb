require 'conversion'

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Conversion
  
  before_action :authenticate_user!, unless: :devise_controller?

  helper_method :km_to_miles
  helper_method :miles_to_km

  def confirm_ownership(elem, message)
    if elem.user != current_user
      flash[:alert] = message
      redirect_to root_path
    end
  end
end

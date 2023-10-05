class RunsController < ApplicationController
  before_action :set_shoe, only: [:new, :create, :edit, :update]
  before_action :set_referrer, only: [:new, :edit]
  before_action :set_destination, only: [:create, :update]
  before_action :set_shoes, only: [:create, :update]

  def index
    #this will be for calendar view
  end

  def show
    #details of the run, separate page
  end

  def new
    @run = Run.new
  end

  def create
    @run = Run.new(processed_run_params.except(:hours, :minutes, :seconds, :distance_units, :referrer))
    @run.user = current_user
    @run.shoe = @shoe

    if @run.save
      respond_to do |format|
        format.html { redirect_to @run, notice: "Run was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Run was successfully created." } 
      end
    else
      render :new, status: :unprocessable_entity
    end
    #possibly also: run show if came from run index?? if end up giving that option -- would require a different form...
  end

  def edit
  end

  def update
    #also will want to redirect based on where you came from (either shoe show or run show)
  end

  def destroy
    #want to redirect to runs index IF came from run show
    #but want to redirect to shoes index IF came from shoe show
  end

  private

  def set_shoe 
    @shoe = Shoe.find(params[:shoe_id])
  end

  def run_params
    params.require(:run)
      .permit(:date, :distance, :distance_units, :hours, :minutes, :seconds, :felt, :referrer)
  end

  def processed_run_params
    # want to store distance in miles and duration in seconds
    processed_params = run_params.deep_dup
    if (run_params[:distance_units] == "km")
      cleaned_distance = km_to_miles(run_params[:distance].to_i).round(2)
      processed_params = processed_params.merge(distance: cleaned_distance)
    end
    duration_in_seconds = run_params[:hours].to_i * 60 * 60 + run_params[:minutes].to_i * 60 + run_params[:seconds].to_i
    processed_params = processed_params.merge(duration: duration_in_seconds, felt: run_params[:felt].to_i)
  end

  def set_referrer
    if request.referrer == root_url || request.referrer == shoes_url
      @referrer = "root"
    else
      @referrer = "shoe"
    end
  end

  def set_destination 
    @destination = run_params[:referrer]
  end

  # ugh -- will this work?? 
  def set_shoes
    return unless @destination == "root"
    @shoes = current_user.shoes.current.order_by_last_run.order_by_creation
  end
end

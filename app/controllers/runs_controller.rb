class RunsController < ApplicationController
  before_action :set_shoe, only: [:new, :create]
  before_action :set_run, only: [:edit, :update, :destroy, :show]

  before_action only: [:show, :edit, :update, :destroy] do
    confirm_ownership(@run, "Only the owner of a run may view or modify it.")
  end

  # before_action :set_referrer, only: [:new, :edit, :destroy, :create, :update]

  def index
    start_date = params.fetch(:start_date, Date.today).to_date
    @runs = Run.where(date: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end

  def new
    @run = Run.new
  end

  def create
    @run = Run.new(processed_run_params.except(:hours, :minutes, :seconds, :distance_units))
    @run.user = current_user
    @run.shoe = @shoe

    if @run.save
      respond_to do |format|
        format.html { redirect_to @shoe, notice: "Run was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Run was successfully created." } 
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @run.update(
      processed_run_params
        .except(:hours, :minutes, :seconds, :distance_units)
    )
      respond_to do |format|
        if request.referrer == edit_run_url(@run)
          format.html { redirect_to runs_path, notice: "Run was successfully updated." } 
        else
          format.html { redirect_to @run.shoe, notice: "Run successfully updated." }
          format.turbo_stream { flash[:now] = "Run was successfully updated." }
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @run.destroy
    respond_to do |format|
      format.html { redirect_to @run.shoe, notice: "Run was successfully deleted." }
      format.turbo_stream { flash[:now] = "Run was successfully deleted." }
    end
  end

  private

  def set_run 
    @run = Run.find(params[:id])
  end

  def set_shoe 
    @shoe = Shoe.find(params[:shoe_id])
  end

  def run_params
    params.require(:run)
      .permit(:date, :distance, :distance_units, :hours, :minutes, :seconds, :felt, :notes)
  end

  def processed_run_params
    # want to store distance in miles and duration in seconds
    processed_params = run_params.deep_dup
    if (run_params[:distance_units] == "km")
      cleaned_distance = km_to_miles(run_params[:distance].to_i)
      processed_params = processed_params.merge(distance: cleaned_distance)
    end
    duration_in_seconds = processed_params[:hours].to_i * 60 * 60 + processed_params[:minutes].to_i * 60 + processed_params[:seconds].to_i
    processed_params = processed_params
      .merge(duration: duration_in_seconds, felt: run_params[:felt].to_i)
  end

  # def set_referrer
  #   if request.referrer == root_url || request.referrer == shoes_url
  #     @referrer = "root"
  #   elsif @run && request.referrer == edit_run_url(@run)
  #     @referrer = "edit"
  #   elsif request.referrer == runs_url
  #     @referrer = "runs"
  #   else
  #     @referrer = "shoe"
  #   end
  # end
end

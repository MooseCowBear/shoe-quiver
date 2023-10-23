class RunsController < ApplicationController
  before_action :set_shoe, only: [:new, :create]
  before_action :set_run, only: [:edit, :update, :destroy, :show]

  before_action only: [:show, :edit, :update, :destroy] do
    confirm_ownership(@run, "Only the owner of a run may view or modify it.")
  end

  def index
    start_date = params.fetch(:start_date, Date.today).to_date
    @runs = Run.where(date: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end

  def new
    @run = Run.new
  end

  def create
    @run = Run.new(Run.process_params(run_params))
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
    if @run.update(Run.process_params(run_params))
      respond_to do |format|
        if request.referrer == edit_run_url(@run)
          format.html { redirect_to runs_path, notice: "Run was successfully updated." } 
        else
          format.html { redirect_to @run.shoe, notice: "Run successfully updated." }
          format.turbo_stream { flash.now[:notice] = "Run was successfully updated." }
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @run.destroy
    
    if @run.shoe_id.nil? || params[:back] == runs_url
      flash[:notice] = "Run was successfully deleted."
      redirect_to runs_path
    else
      respond_to do |format|
        format.html { redirect_to @run.shoe, notice: "Run was successfully deleted." } 
        format.turbo_stream { flash.now[:notice] = "Run was successfully deleted." }
      end
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
end

class RunsController < ApplicationController
  def index
    #this will be for calendar view
  end

  def show
    #details of the run, separate page
  end

  def new
  end

  def create
    # need to update SHOE mileage

    #want to redirect to shoes index if came from there
    #want to redirect to shoe show if came from there
    #possibly also: run show if came from run index?? if end up giving that option
  end

  def edit
  end

  def update
    # need to update SHOE MILEAGE
    
    #also will want to redirect based on where you came from (either shoe show or run show)
  end

  def destroy
    #want to redirect to runs index IF came from run show
    #but want to redirect to shoes index IF came from shoe show
  end
end

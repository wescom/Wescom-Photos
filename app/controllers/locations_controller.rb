class LocationsController < ApplicationController
  before_action :require_admin, only: [:show, :edit, :update]

  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if params[:cancel_button]
      redirect_to locations_url
    else
      if @location.update_attributes(location_params)
        flash_message :notice, "Location updated"
        redirect_to locations_url
      else
        render :action => :edit
      end
    end
  end

  private
    def location_params
      params.require(:location).permit(:newspaper_name, :short_url_newspaper_name, :location_no)
    end
end

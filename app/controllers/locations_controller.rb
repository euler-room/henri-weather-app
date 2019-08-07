class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy, :toggle_temp_units, :refresh]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @weather_data = OpenWeatherService.new(@location).perform
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    location_data = ZipCodeService.new(location_params[:zip]).perform

    location_attrs = {
      zip: location_data[:zip_code],
      city: location_data[:city],
      state: location_data[:state]
    }
    @location = Location.new(location_attrs)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_temp_units
    @weather_data = OpenWeatherService.new(@location).perform(c_to_f_params[:units])
    @weather_data.slice(:temp, :temp_max, :temp_min)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.fetch(:location, {}).permit(:zip)
    end

    def c_to_f_params
      params.fetch(:location, {}).permit(:units)
    end
end

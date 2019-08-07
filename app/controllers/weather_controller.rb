class WeatherController < ApplicationController
  def index
    @locations = Locations.order(:zip)
  end
end

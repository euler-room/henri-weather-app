class ZipCodeService < ServiceBase
  ZIP_API_KEY = Rails.application.secrets.zip_api_key
  ZIP_API_BASE_URL = "https://www.zipcodeapi.com/rest/#{ZIP_API_KEY}/info.json/"
  attr_accessor :zip

  def initialize(zipcode)
    self.zip = zipcode
  end

  def perform
    res = HTTParty.get(zip_api_url, format: :json)
                  .parsed_response
                  .symbolize_keys
                  .slice(:city, :state, :zip_code)
  end

  def zip_api_url
    URI.parse("#{ZIP_API_BASE_URL}#{zip}/degrees")
  end
end

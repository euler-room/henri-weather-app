require 'rails_helper'

RSpec.describe ZipCodeService, type: :service do
  let(:zip){"90210"}
  let(:api_url){"https://www.zipcodeapi.com/rest/#{Rails.application.secrets.zip_api_key}/info.json/#{zip}/degrees"}
  let(:subject){ ZipCodeService.new(zip) }
  it "should return city and state" do
    VCR.use_cassette(:zip_data) do
      expect(subject.perform).to eq({:city=>"Beverly Hills", :state=>"CA", :zip_code=>"90210"})
    end
  end
  it "should return the proper zip api url" do
    expect(subject.zip_api_url.to_s).to eq(api_url)
  end
end

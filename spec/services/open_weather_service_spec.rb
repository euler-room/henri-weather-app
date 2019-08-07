require 'rails_helper'

RSpec.describe OpenWeatherService, type: :service do
  let(:location){ Location.new(zip: "90210", city: "Beverly Hills", state: "CA")}
  let(:subject){ described_class.new(location) }
  let(:sunrise){DateTime.new(2019,1,1,6,0,0)}
  let(:sunset){DateTime.new(2019,1,1,20,0,0)}
  let(:day){DateTime.new(2019,1,1,12,0,0)}
  let(:night){DateTime.new(2019,1,1,23,0,0)}
  it "should determine if it is day" do
    expect(subject.daylight?(sunrise, sunset, day)).to eq(true)
  end
  it "should determine if it is night" do
    expect(subject.daylight?(sunrise, sunset, night)).to eq(false)
  end
  it "should return the proper icon_url for nighttime" do
    expect(subject.get_icon_url("771", false)).to eq("http://openweathermap.org/img/wn/50n@2x.png")
  end
  it "should return the proper icon_url for daytime" do
    expect(subject.get_icon_url("771", true)).to eq("http://openweathermap.org/img/wn/50d@2x.png")
  end
  it "return the proper open weather api url" do
    target_url = "http://api.openweathermap.org/data/2.5/weather?APPID=#{Rails.application.secrets.open_weather_key}&zip=#{subject.instance_variable_get(:@location).zip},us&units=imperial"
    expect(subject.open_weather_url('imperial')).to eq(target_url)
  end
  it "should fetch OpenWeather data" do
    VCR.use_cassette(:get_open_weather_data) do
      expect(subject.perform('imperial')).to eq({:temp=>80.22, :pressure=>1014, :humidity=>48, :temp_min=>66.99, :temp_max=>91.99, :weather=>"Thunderstorm", :icon_url=>"http://openweathermap.org/img/wn/11d@2x.png", :units=>"imperial"})
    end
  end
end

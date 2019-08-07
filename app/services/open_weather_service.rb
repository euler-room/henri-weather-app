class OpenWeatherService < ServiceBase
  OPEN_WEATHER_KEY = Rails.application.secrets.open_weather_key
  DEFAULT_UNITS = 'imperial'
  OPEN_WEATHER_BASE_URL = "http://api.openweathermap.org/data/2.5/weather?APPID=#{OPEN_WEATHER_KEY}"
  WEATHER_CODE_MAP = {
    "200": "11",
    "201": "11",
    "202": "11",
    "210": "11",
    "211": "11",
    "212": "11",
    "221": "11",
    "230": "11",
    "231": "11",
    "232": "11",
    "300": "09",
    "301": "09",
    "302": "09",
    "310": "09",
    "311": "09",
    "312": "09",
    "313": "09",
    "314": "09",
    "321": "09",
    "500": "10",
    "501": "10",
    "502": "10",
    "503": "10",
    "504": "10",
    "511": "13",
    "520": "09",
    "521": "09",
    "522": "09",
    "531": "09",
    "600": "13",
    "601": "13",
    "602": "13",
    "611": "13",
    "612": "13",
    "613": "13",
    "615": "13",
    "616": "13",
    "620": "13",
    "621": "13",
    "622": "13",
    "701": "50",
    "711": "50",
    "721": "50",
    "731": "50",
    "741": "50",
    "751": "50",
    "761": "50",
    "762": "50",
    "771": "50",
    "781": "50",
    "800": "01",
    "801": "02",
    "802": "03",
    "803": "04",
    "804": "04" }

  def initialize(location)
    @location = location
  end

  def perform(units)
    res = HTTParty.get(open_weather_url(units)).parsed_response
    is_daylight = daylight?(res["sys"]["sunrise"], res["sys"]["sunset"])
    icon_url = get_icon_url(res["weather"][0]["id"], is_daylight)
    res = res["main"].merge({ "weather": res["weather"][0]["main"],
                              "icon_url": icon_url,
                              "units": units })

    res.symbolize_keys
  end

  def daylight?(sr, ss, now = nil)
    now = Time.now unless now
    (Time.at(sr)..Time.at(ss)).include? now
  end

  def get_icon_url(icon_key, is_daylight)
    icon_code = "#{WEATHER_CODE_MAP[icon_key.to_s.to_sym]}#{is_daylight ? 'd' : 'n'}"
    "http://openweathermap.org/img/wn/#{icon_code}@2x.png"
  end

  def open_weather_url(units)
    "#{OPEN_WEATHER_BASE_URL}&zip=#{@location.zip},us&units=#{units}"
  end
end

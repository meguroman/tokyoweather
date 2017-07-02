require 'json'
require 'open-uri'

class Weather
  API_KEY = ENV['WEATHER_API_KEY']
  CITY_ID = '1850147' #Tokyo
  UNITS = 'imperial'
  BASE_URL = 'http://api.openweathermap.org/data/2.5/forecast'

  def initialize
    @weather = request
  end

  def description
    current['weather'].first['description']
  end

  def temperature
    current['main']['temp']
  end

  def humidity
    current['main']['humidity']
  end

  private

  def request
    res = open(BASE_URL + "?id=#{CITY_ID}&APPID=#{API_KEY}&units=#{UNITS}").read
    JSON.parse(res)
  end

  def current
    @weather['list'].first
  end
end

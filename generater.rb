require_relative './weather.rb'
require 'aws-sdk'
require 'pp'

class Generater
  def initialize
    @weather = Weather.new
  end

  def generate_speech
    speech = "It is #{@weather.description} now in Tokyo." +
             " Temperature is #{@weather.temperature} °F." +
             " Humidity is #{@weather.humidity}%." +
             " Thank you for listening. Have a nice day."
    speech
  end

  def format_flash_briefing_json(speech)
    fb_json = {}
    fb_json['uid'] = 'rooter-tokyoweather-1'
    fb_json['updateDate'] = Time.now.strftime("%Y-%m-%dT%H:%M:%S.0Z")
    fb_json['titleText'] = 'Latest Tokyo\'s weatehr.'
    fb_json['mainText'] = speech
    [fb_json].to_json
  end

  def upload_to_s3(output)
    client = Aws::S3::Client.new(
      :region => 'us-east-1',
      :access_key_id => ENV['ACCESS_KEY_ID'],
      :secret_access_key => ENV['SECRET_ACCESS_KEY']
    )
    client.put_object(
      :bucket => 'rooter-alexa',
      :key    => 'tokyoweather/tokyoweather.json',
      :body   => output
    )
  end
end


##################
###    main    ###
##################
g = Generater.new
speech = g.generate_speech
output = g.format_flash_briefing_json(speech)
g.upload_to_s3(output)

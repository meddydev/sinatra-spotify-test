require 'base64'
require 'json'
require 'net/http'
require 'uri'
require "sinatra/base"
require "sinatra/reloader"

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  def get_token(code, redirect_uri)
    client_id = "f2d6ba856e704218bd694b1f843e5381"
    client_secret = "8e0ae949c1a14522952d71080e28bbd4"
    grant = Base64.strict_encode64("#{client_id}:#{client_secret}")
  
    uri = URI.parse('https://accounts.spotify.com/api/token')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
  
    header = { 'Authorization' => "Basic #{grant}" }
    req = Net::HTTP::Post.new(uri.request_uri, header)
    data = { 'grant_type' => 'authorization_code',
             'code' => code, 'redirect_uri' => redirect_uri }
    req.set_form_data(data)
  
    res = http.request(req)
    if res.kind_of? Net::HTTPSuccess
      json = JSON.parse(res.body)
      json['access_token']
    end
  end

  get "/" do
    "Hello World!"
    @client_id = "f2d6ba856e704218bd694b1f843e5381"
    @redirect_uri = "#{request.base_url}/callback/spotify"
    erb :index
  end

  get "/callback/spotify" do
    code = params["code"]
    redirect_uri = "#{request.base_url}/callback/spotify"
    token = get_token(code, redirect_uri)
    "token: #{token.inspect}"
  end
end

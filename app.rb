require 'base64'
require 'json'
require 'net/http'
require 'uri'
require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/auth"

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  def access_api
    Auth.new("f2d6ba856e704218bd694b1f843e5381","8e0ae949c1a14522952d71080e28bbd4")
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
    api = access_api
    token = api.get_token(code, redirect_uri)
    "token: #{token.inspect}"
  end
end

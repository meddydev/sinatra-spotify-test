require "base64"
require "json"
require "net/http"
require "uri"
require "sinatra/base"
require "sinatra/reloader"
require "similar_text"

require_relative "lib/auth"
require_relative "lib/spotify_api"

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  def access_api
    Auth.new("f2d6ba856e704218bd694b1f843e5381", "8e0ae949c1a14522952d71080e28bbd4")
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
    auth = access_api
    token = auth.get_token(code, redirect_uri)

    api = SpotifyApi.new(token)
    # recently_played = api.get_recently_played
    most_popular = api.get_popular_artists
    random_number = rand(0..99)
    random_artist_id = most_popular.values[random_number]
    @random_artist_name = most_popular.key(random_artist_id)

    # most_popular.to_s
    # p random_artist_id
    @top_tracks = api.get_top_tracks_by_artist_id(random_artist_id)
    # return random_artist_name.to_s + top_tracks.to_s
    erb :guess
  end

#   get "/results" do
#     p params
#   end

  post "/results" do
    @guess_1 = params[:guess_song_1]
    @acc_1 = params[:real_song_1]
    @similarity_1 = @guess_1.similar(@acc_1)

    @guess_2 = params[:guess_song_2]
    @acc_2 = params[:real_song_2]
    @similarity_2 = @guess_2.similar(@acc_2)

    @guess_3 = params[:guess_song_3]
    @acc_3 = params[:real_song_3]
    @similarity_3 = @guess_3.similar(@acc_3)

    @guess_4 = params[:guess_song_4]
    @acc_4 = params[:real_song_4]
    @similarity_4 = @guess_4.similar(@acc_4)

    @guess_5 = params[:guess_song_5]
    @acc_5 = params[:real_song_5]
    @similarity_5 = @guess_5.similar(@acc_5)

    erb :results
  end
end

class SpotifyApi
  def initialize(token)
    @token = token
    @base_url = "https://api.spotify.com/v1"
  end

  def get_recently_played
    json = get_json("/me/player/recently-played")
    display_string = "Your recently played tracks are: \n"

    items = json["items"]
    "'#{items[0]["track"]["name"]}'" + " by '#{items[0]["track"]["album"]["artists"][0]["name"]}'"

    items.each_with_index do |item, index|
      display_string += "'#{items[index]["track"]["name"]}'" + " by '#{items[index]["track"]["album"]["artists"][0]["name"]}'\n"
    end

    display_string
  end

  def get_popular_artists
    json = get_json("/playlists/0Hm1tCeFv45CJkNeIAtrfF?si=a87132e260a74789/tracks?tracks?fields=items(track(name%2Chref%2Calbum(name%2Chref)))")
    items = json["tracks"]["items"]

    most_popular_artists = {}

    items.each do |item|
      name = item["track"]["album"]["artists"][0]["name"]
      id = item["track"]["album"]["artists"][0]["id"]
      most_popular_artists.store(name, id)
    end
    # p tracks["items"][0]["track"]["album"]["artists"][0]["name"]
    # p tracks["items"][0]["track"]["name"]

    # p most_popular_artists
    most_popular_artists
  end

  def get_top_tracks_by_artist_id(id)
    json = get_json("/artists/#{id}/top-tracks?market=GB")
    tracks = json["tracks"].slice(0, 5)

    top_tracks = []

    tracks.each do |track|
      p track["name"]
      top_tracks << track["name"]
    end

    top_tracks
  end

#   def get_me
#     json = get_json("/me")
#   end

  private

  def get_json(path)
    uri = URI.parse("#{@base_url}#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    header = { "Authorization" => "Bearer #{@token}" }
    req = Net::HTTP::Get.new(uri.request_uri, header)

    res = http.request(req)

    if res.kind_of? Net::HTTPSuccess
      JSON.parse(res.body)
    end
  end
end

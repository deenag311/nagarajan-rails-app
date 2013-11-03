json.array!(@urls) do |url|
  json.extract! url, :url, :key
  json.url url_url(url, format: :json)
end

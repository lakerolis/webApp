json.array!(@videos) do |video|
  json.extract! video, :id, :title, :image_url, :rating, :video_url, :duration, :hand_picked
  json.url video_url(video, format: :json)
end

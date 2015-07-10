class CatalogController < ApplicationController
  def index
    @top_rated = Array.new
    Video.where(hand_picked: false).find_each do |video|
      @top_rated << video
    end
    @hand_picked = Video.find_by_hand_picked(true)
  end
end

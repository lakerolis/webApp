class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.all

    if params['updatecatalog'] == '1'
      require 'open-uri'
      require 'nokogiri'

      videos = Array.new
      raw_video_list = Array.new

      doc = Nokogiri::HTML(open('http://www.tubegalore.com/Amateur%257CAmatuer%257CAmature-tube/5457-1/page0/rating/'))
      doc.css('div.itemContainerSub.sub').each do |video_html|
        raw_video_list << video_html
      end

      raw_video_list.each do |video_data|
        video = Video.new

        # video link
        link = video_data.css('.imgContainer a').map{|link| link['href']}
        link = link.to_s
        temp = 'http://' << link.split('http://')[1]
        unless link.include?('pornxs') || link.include?('pornhub')
          video.video_url = temp.split('?')[0]
        else
          video.video_url = temp.split('&')[0]
        end
        # title
        data = video_data.css('.title')
        video.title = data.text
        # rating
        data = video_data.css('.rating').map{|rating| rating['value']}
        video.rating = data[0].to_i
        # image_url
        data = video_data.css('.imgContainer a img').map{|img| img['src']}
        video.image_url = data[0]
        # duration
        data = video_data.css('.length')
        video.duration = data.text
        # handpicked
        video.hand_picked = false

        videos << video
      end
      # videos.each{|video| video.save}
      videos.each do|video|
        catalog_item = Video.find_or_initialize_by(title: video.title)
        catalog_item.update(title: video.title, video_url:video.video_url, image_url: video.image_url, rating: video.rating, duration: video.duration, hand_picked: video.hand_picked)
      end
      # videos.each{|video| Video.find_or_create_by(video_url: video.video_url)}
    end
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_video
    @video = Video.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def video_params
    params.require(:video).permit(:title, :image_url, :rating, :video_url, :duration, :hand_picked)
  end
end

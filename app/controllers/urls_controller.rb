class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy]

  # GET /urls
  # GET /urls.json
  def index
    @url = Url.new
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(url_params)
    respond_to do |format|
      if @url.key.empty? && create_key.nil?
        @url = Url.find_by_url(@url.url)
        format.html { redirect_to @url }
        format.json { render action: 'show', location: @url }
      else
        if @url.save
          format.html { redirect_to @url }
          format.json { render action: 'show', status: :created, location: @url }
        else
          format.html { render action: 'index' }
          format.json { render json: @url.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def create_key
    if Url.find_by_url(@url.url).nil?
      key_base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split(//)
      base = key_base.length
      Url.last.nil? ? id = 1 : id = Url.last.id * 1000 
      key = ''
      while id > 0
        key << key_base[id.modulo(base)]
        id /= base
      end
      @url.key = key.reverse
    else
      nil
    end    
  end

  def redirect
    @url = Url.find_by_key(params[:key])
    redirect_to "http://#{@url.url}" 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_params
      params.require(:url).permit(:url, :key)
    end
end

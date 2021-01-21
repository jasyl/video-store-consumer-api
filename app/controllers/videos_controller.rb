class VideosController < ApplicationController
  before_action :require_video, only: [:show]

  def index
    if params[:query]
      data = VideoWrapper.search(params[:query])
    else
      data = Video.all
    end

    render status: :ok, json: data
  end

  def add_video
    new_video = Video.new(external_id: video_params[:external_id], title: video_params[:title], overview: video_params[:overview], release_date: video_params[:release_date], image_url: video_params[:image_url], inventory: 5)

    if !Video.find_by(external_id: new_video.external_id) && new_video.external_id != nil
      if new_video.save
        render status: :ok, json: {}
      else
        render status :bad_request, json: {errors: "This video already exists in the Library"}
      end
    end
  end

  def show
    render(
      status: :ok,
      json: @video.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  private

  def require_video
    @video = Video.find_by(title: params[:title])
    unless @video
      render status: :not_found, json: { errors: { title: ["No video with title #{params["title"]}"] } }
    end
  end

  def video_params
    return params.permit(:external_id, :title, :inventory, :overview, :release_date, :image_url)
  end
end


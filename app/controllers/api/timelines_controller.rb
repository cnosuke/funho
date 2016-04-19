class Api::TimelinesController < ApiController
  def create
    @timeline = Timeline.new(timeline_params)

    respond_to do |f|
      if @timeline.save
        f.json { render json: { status: :success } }
      else
        f.json { render json: { status: :error } }
      end
    end
  end

  private

  def timeline_params
    params.
      require(:timeline).
      permit(:kind, :comment)
  end
end

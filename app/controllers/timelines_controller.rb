class TimelinesController < ApplicationController
  # GET /timelines
  # GET /timelines.json
  def index
    @timelines = current_user.timelines.latest.limit(100)
  end
end

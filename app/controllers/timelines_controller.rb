class TimelinesController < ApplicationController
  # GET /timelines
  # GET /timelines.json
  def index
    @timelines = Timeline.latest.limit(100)
  end
end

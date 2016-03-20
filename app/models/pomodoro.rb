class Pomodoro < ActiveRecord::Base
  DEFAULT_DURATION = 25.minutes

  belongs_to :task

  def timelines
    ft = (finished_at.presence || (started_at + DEFAULT_DURATION))
    Timeline.where(created_at: started_at..ft)
  end
end

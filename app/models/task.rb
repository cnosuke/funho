class Task < ActiveRecord::Base

  has_many :pomodoros

  def timelines
    # FIXME: N+1 query
    pomodoros.map(&:timelines).flatten.uniq.sort
  end
end

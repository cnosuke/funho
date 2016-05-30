class PagesController < ApplicationController
  skip_before_action :authenticate, only: %i(index)

  def index
    @tasks = current_user&.tasks
  end

  def stats
    @recent_pomodoros = Pomodoro
      .between(1.weeks.ago.beginning_of_day, 1.days.ago.end_of_day)
      .select(&:finished?)
      .group_by { |e| e.started_at.wday }
    @today_pomodoros = Pomodoro
      .recent(Time.now.beginning_of_day)
  end
end

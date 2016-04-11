module ApplicationHelper
  def f_time(time)
    time&.strftime('%m/%d %T')
  end

  def pmdr_time(seconds)
    min = (seconds / 60).to_i
    sec = (seconds % 60).to_i
    "#{min}m #{sec}s"
  end
end

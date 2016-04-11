class Pomodoro < ActiveRecord::Base
  DEFAULT_DURATION = 2.minutes

  belongs_to :task

  scope :latest, -> { order(:started_at) }

  def timelines
    ft = (finished_at.presence || (started_at + DEFAULT_DURATION))
    Timeline.where(created_at: started_at..ft)
  end

  def running?
    started_at && suspended_at.nil? && finished_at.nil?
  end

  def start!(time = Time.now)
    return false unless startable?

    if suspended_at
      self.suspend_duration = suspend_duration + (time - suspended_at)
      self.suspended_at = nil
      save
    elsif started_at.blank?
      update_attributes(started_at: time)
    end
  end


  def stop!(time = Time.now)
    return false unless stoppable?

    if (time - started_at) > DEFAULT_DURATION
      update_attributes(finished_at: time)
    else
      update_attributes(suspended_at: time)
    end
  end

  def stoppable?
    started_at && suspended_at.nil? && finished_at.nil?
  end

  def startable?
     !finished? && (suspended_at || started_at.nil?)
  end

  def finished?
    remain_time <= 0
  end

  def remain_time
      DEFAULT_DURATION - duration_time
  end

  def duration_time(time = Time.now)
    return 0 unless started_at
    d_time = (finished_at || suspended_at || time) -
      started_at -
      suspend_duration.seconds
    d_time > DEFAULT_DURATION ? DEFAULT_DURATION : d_time
  end
end

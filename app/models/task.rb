class Task < ActiveRecord::Base

  has_many :pomodoros
  belongs_to :user

  scope :owner, -> (u) { where(user_id: u.id) }

  def timelines
    # FIXME: N+1 query
    pomodoros.map(&:timelines).flatten.uniq.sort
  end
end

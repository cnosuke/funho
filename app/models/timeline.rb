class Timeline < ActiveRecord::Base
  KIND_TWEET = :tweet
  KIND_INTERRUPT = :interrupt
  KIND_KEEP = :keep
  KIND_OTHER = :other
  KINDS = [KIND_TWEET, KIND_INTERRUPT, KIND_KEEP, KIND_OTHER]

  belongs_to :user

  scope :owner, -> (u) { where(user_id: u.id) }
  scope :latest, -> { order(created_at: :desc) }
  scope :pomodoro_by, -> (pmdr) {
    end_at = (pmdr.started_at + pmdr.duration_time + pmdr.suspend_duration.seconds)
    range = pmdr.started_at..end_at
    where(created_at: range)
  }

  scope :kind, -> (k) { where(kind: k) }
  KINDS.each do |kind_type|
    scope kind_type, -> { kind(kind_type) }
  end
end

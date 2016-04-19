class Timeline < ActiveRecord::Base
  KIND_TWEET = :tweet
  KIND_INTERRUPT = :interrupt
  KIND_KEEP = :keep
  KIND_OTHER = :other
  KINDS = [KIND_TWEET, KIND_INTERRUPT, KIND_KEEP, KIND_OTHER]

  scope :latest, -> { order(created_at: :desc) }

  scope :kind, -> (k) { where(kind: k) }
  KINDS.each do |kind_type|
    scope kind_type, -> { kind(kind_type) }
  end
end

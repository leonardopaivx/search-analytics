class SearchTerm < ApplicationRecord
  belongs_to :visitor_session
  validates :term, :first_seen_at, :last_seen_at, presence: true

  scope :top, ->(limit = 10) { order(occurences: :desc).limit(limit) }
end

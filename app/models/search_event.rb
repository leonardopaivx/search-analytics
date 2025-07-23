class SearchEvent < ApplicationRecord
  belongs_to :visitor_session
  validates :query, :typed_at, presence: true
end

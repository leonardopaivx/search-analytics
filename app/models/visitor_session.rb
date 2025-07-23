class VisitorSession < ApplicationRecord
  has_many :search_events, dependent: :destroy
  has_many :search_terms,  dependent: :destroy

  validates :session_token, :ip_address, presence: true
end

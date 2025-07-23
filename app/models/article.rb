class Article < ApplicationRecord
  validates :title, :content, presence: true
  scope :search, ->(q) {
    where('title ILIKE :q OR content ILIKE :q', q: "%#{q}%")
  }
end

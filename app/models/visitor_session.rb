class VisitorSession < ApplicationRecord
  ADJECTIVES = %w[Blue Red Swift Silent Bright Clever Lucky Brave Bold Quiet Fuzzy Rapid Mystic].
    freeze

  ANIMALS = %w[Tiger Panda Falcon Otter Fox Whale Lynx Owl Eagle Koala Wolf Dolphin].
    freeze

  has_many :search_events, dependent: :destroy
  has_many :search_terms,  dependent: :destroy

  validates :session_token, :ip_address, presence: true

  before_validation :assign_display_name, on: :create

  private

  def assign_display_name
    return if display_name.present?

    10.times do
      candidate = "#{ADJECTIVES.sample} #{ANIMALS.sample}"
      unless self.class.exists?(display_name: candidate)
        self.display_name = candidate
        break
      end
    end

    self.display_name ||= "Visitor #{SecureRandom.hex(3)}"
  end
end

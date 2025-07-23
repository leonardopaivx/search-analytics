module SearchEvents
  class Payload
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :query, :string
    attribute :final, :boolean, default: false
    attribute :typed_at, :datetime, default: -> { Time.current }

    validates :query, presence: true, length: { minimum: 2 }
  end
end

FactoryBot.define do
  factory :search_event do
    association :visitor_session
    query     { "hello world" }
    typed_at  { Time.current }
    request_id { SecureRandom.uuid }
  end
end

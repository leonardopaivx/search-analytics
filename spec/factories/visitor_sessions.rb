FactoryBot.define do
  factory :visitor_session do
    ip_address   { '127.0.0.1' }
    user_agent   { 'RSpec' }
    session_token { SecureRandom.hex(16) }

    trait :with_search_term do
      after(:create) { |s| create(:search_term, visitor_session: s) }
    end
  end
end

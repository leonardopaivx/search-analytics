FactoryBot.define do
  factory :search_term do
    visitor_session { nil }
    term { 'MyString' }
    occurences { 1 }
    first_seen_at { '2025-07-22 22:35:56' }
    last_seen_at { '2025-07-22 22:35:56' }
  end
end

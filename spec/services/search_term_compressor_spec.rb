require "rails_helper"

RSpec.describe SearchTermCompressor do
  let(:visitor_session) { create(:visitor_session) }
  let(:service)         { described_class.new(visitor_session) }

  it "creates a new SearchTerm on first final event" do
    final_event = create(:search_event, visitor_session: visitor_session, query: "hello")

    expect {
      service.ingest!(final_event)
    }.to change(SearchTerm, :count).by(1)

    st = visitor_session.search_terms.first
    expect(st.term).to eq("hello")
    expect(st.occurences).to eq(1)
  end

  it "increments occurences when term already exists" do
    create(:search_term, visitor_session: visitor_session, term: "hello", occurences: 3)
    final_event = create(:search_event, visitor_session: visitor_session, query: "hello")

    expect {
      service.ingest!(final_event)
    }.not_to change(SearchTerm, :count)

    expect(visitor_session.search_terms.find_by(term: "hello").occurences).to eq(4)
  end

  it "ignores blank terms" do
    event = build_stubbed(:search_event, visitor_session: visitor_session, query: "   ", typed_at: Time.current)

    expect {
      service.ingest!(event)
    }.not_to change(SearchTerm, :count)
  end
end
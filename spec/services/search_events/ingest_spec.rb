require "rails_helper"

RSpec.describe SearchEvents::Ingest do
  let(:visitor_session) { create(:visitor_session) }

  it "persists final event and calls compressor" do
    payload    = SearchEvents::Payload.new(query: "car", final: true, typed_at: Time.current)
    compressor = instance_double(SearchTermCompressor, ingest!: true)
    allow(SearchTermCompressor).to receive(:new).with(visitor_session).and_return(compressor)

    expect {
      described_class.call(session: visitor_session, payload: payload)
    }.to change(SearchEvent, :count).by(1)

    expect(compressor).to have_received(:ingest!)
  end

  it "does nothing for non-final payloads" do
    payload = SearchEvents::Payload.new(query: "car", final: false, typed_at: Time.current)

    expect {
      described_class.call(session: visitor_session, payload: payload)
    }.not_to change(SearchEvent, :count)
  end

  it "ignores blank query" do
    payload = SearchEvents::Payload.new(query: "  ", final: true, typed_at: Time.current)

    expect {
      described_class.call(session: visitor_session, payload: payload)
    }.not_to change(SearchEvent, :count)
  end
end
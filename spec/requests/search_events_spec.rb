require "rails_helper"

RSpec.describe "SearchEvents", type: :request do
  let!(:session) { create(:visitor_session) }

  it "accepts JSON payload and returns 202" do
    headers = { "CONTENT_TYPE" => "application/json" }
    payload = { query: "rails", final: true, typed_at: Time.current }.to_json

    expect {
      post "/search_events", params: payload, headers: headers
    }.to change(SearchEvent, :count).by(1)

    expect(response).to have_http_status(:accepted)
  end

  it "ignores blank query" do
    headers = { "CONTENT_TYPE" => "application/json" }
    post "/search_events", params: { query: "", final: true }.to_json, headers: headers
    expect(response).to have_http_status(:no_content).or have_http_status(:ok)
    expect(SearchEvent.count).to eq(0)
  end
end

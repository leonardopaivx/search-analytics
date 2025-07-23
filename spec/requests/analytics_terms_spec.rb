require "rails_helper"

RSpec.describe "Analytics Terms JSON", type: :request do
  before do
    session = create(:visitor_session, display_name: "Foo")
    create(:search_term, visitor_session: session, term: "rails", occurences: 5)
  end

  it "returns structured JSON" do
    get "/analytics/terms.json", params: { period: "7d" }

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["terms"]).to be_an(Array)
    expect(json["terms"].first).to include("term", "total")
  end
end

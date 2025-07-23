require "rails_helper"

RSpec.describe Analytics::TermsReport do
  let!(:session) { create(:visitor_session) }

  before do
    create(:search_term, visitor_session: session, term: "ruby", occurences: 3)
    create(:search_term, visitor_session: session, term: "rails", occurences: 2)
  end

  it "returns a Result with collections" do
    result = described_class.call(period: "7d")
    expect(result.top_terms).to be_present
    expect(result.top_visitors).to be_present
    expect(result.terms_by_visitor).to be_present
  end
end

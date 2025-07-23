require "rails_helper"

RSpec.describe VisitorSession, type: :model do
  it "generates a display_name on create" do
    vs = create(:visitor_session)
    expect(vs.display_name).to be_present
  end

  it "does not change display_name on update" do
    vs = create(:visitor_session)
    name = vs.display_name
    vs.update!(updated_at: Time.current)
    expect(vs.reload.display_name).to eq(name)
  end
end

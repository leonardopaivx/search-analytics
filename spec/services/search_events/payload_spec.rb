require 'rails_helper'

RSpec.describe SearchEvents::Payload do
  it 'is valid with query and final' do
    p = described_class.new(query: 'hello', final: true)
    expect(p).to be_valid
  end

  it 'is invalid when query is blank' do
    p = described_class.new(query: '')
    expect(p).not_to be_valid
  end
end

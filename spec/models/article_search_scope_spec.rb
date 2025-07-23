require 'rails_helper'

RSpec.describe Article, '.search', type: :model do
  subject(:result) { described_class.search(query) }

  let!(:rails_article) { create(:article, title: 'Ruby on Rails Patterns', content: 'Active Record callbacks and services') }
  let!(:js_article)    { create(:article, title: 'Vanilla JS Tricks', content: 'Debounce, throttle and DOM tips') }
  let!(:poem_article)  { create(:article, title: 'The Raven', content: 'Once upon a midnight dreary') }

  context 'when query is nil' do
    let(:query) { nil }
    it { expect(result).to match_array([ rails_article, js_article, poem_article ]) }
  end

  context 'when query is empty' do
    let(:query) { '' }
    it { expect(result).to match_array([ rails_article, js_article, poem_article ]) }
  end

  context 'when searching by title' do
    let(:query) { 'Rails' }
    it { expect(result).to contain_exactly(rails_article) }
  end

  context 'when searching by content' do
    let(:query) { 'debounce' }
    it { expect(result).to contain_exactly(js_article) }
  end

  context 'when multiple records match' do
    let(:query) { 'the' }
    it { expect(result).to include(poem_article) }
  end

  it 'returns an ActiveRecord::Relation' do
    expect(described_class.search('x')).to be_a(ActiveRecord::Relation)
  end
end

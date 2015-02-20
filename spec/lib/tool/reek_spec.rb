require 'rails_helper'

describe Tool::Reek do
  it_behaves_like 'a tool', Hash

  describe '.parse' do
    it 'parses yaml into a hash' do
      expect(subject.class.parse "---\nfoo: bar").to eq(
        result: { 'foo' => 'bar' }
      )
    end

    it 'returns an empty hash when output is not valid yaml' do
      expect(subject.class.parse '*').to eq({})
    end
  end
end

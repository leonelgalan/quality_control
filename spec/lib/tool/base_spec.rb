require 'rails_helper'

describe Tool::Base do
  describe '.run' do
    it 'fails when command is called and not implemented' do
      expect { subject.class.run '' }.to raise_error NotImplementedError
    end
  end

  describe '.parse' do
    it 'parses json into a hash' do
      expect(subject.class.parse '{"foo": "bar"}').to eq({'foo' => 'bar'})
    end

    it 'returns an empty hash when output is not valid json' do
      expect(subject.class.parse 'foo').to eq({})
    end
  end
end

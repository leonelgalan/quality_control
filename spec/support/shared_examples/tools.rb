shared_examples 'a tool' do |klass|
  describe '.run' do
    it "should return a #{klass}" do
      output = subject.class.run('.')
      expect(output.class).to be klass
    end
  end
end

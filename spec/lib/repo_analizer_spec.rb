require 'rails_helper'

describe RepoAnalizer do
  subject(:analizer) { RepoAnalizer.new 'token', 'foo/bar' }
  let(:archive) { 'spec/support/files/archive.tar.gz' }
  # Preserve my original archive for other tests
  let(:test_archive) { 'archive.tar.gz' }
  let(:tools) { [:rubocop] }

  describe '#run!' do
    before do
      analizer.instance_variable_set :@archive, test_archive
      allow(analizer).to receive(:archive_link) do
        "file://#{File.join(Rails.root, archive)}"
      end
    end

    it 'returns a hash with the tools' do
      expect(analizer.run!(tools).class).to be Hash
    end

    it 'should return keys for each tool passed' do
      expect(analizer.run! tools).to have_key tools.first
    end
  end

  # I decided to test private methods, deal with it!
  context 'private methods:' do
    let(:folder) { 'folder' }

    before { analizer.instance_variable_set :@archive, archive }

    describe '#client' do
      it 'should return an OctoKit::Client' do
        expect(analizer.send(:client).class).to be Octokit::Client
      end
    end

    describe '#archive_link' do
      let(:client) { double 'OctoKit::Client' }
      before { allow(analizer).to receive(:client) { client } }

      it 'should return an OctoKit::Client' do
        expect(client).to receive(:archive_link)
        analizer.send :archive_link
      end
    end

    describe '#tool_class' do
      it 'should raise NotImplementedError when given non-existent tool' do
        expect do
          analizer.send :tool_class, :foo
        end.to raise_error NotImplementedError
      end
    end

    describe '#read_folder' do
      it 'should read folder inside archive.tar.gz' do
        expect(analizer.send :read_folder).to eq "#{folder}/"
      end
    end

    describe '#untar' do
      it 'should extract files inside archive' do
        analizer.send :untar
        expect(File.exist? "#{folder}/file").to be true

        FileUtils.rm_rf File.join(Rails.root, folder)
      end
    end

    describe '#delete' do
      before do
        analizer.instance_variable_set :@archive, test_archive
        FileUtils.cp_r(archive, test_archive)
      end

      it 'should delete archive' do
        analizer.send :delete
        expect(File.exist? test_archive).to be false
      end

      it 'should delete folder' do
        analizer.instance_variable_set :@folder, folder
        FileUtils.mkdir folder

        analizer.send :delete
        expect(Dir.exist? folder).to be false
      end
    end

    describe '#run_tools' do
      let(:tool_class) { double 'Tool::Rubocop' }

      before do
        analizer.instance_variable_set :@folder, folder
        allow(analizer).to receive(:tool_class) { tool_class }
      end

      it 'should call run on given tools' do
        expect(tool_class).to receive(:run).with(folder)

        analizer.send :run_tools!, tools
      end
    end
  end
end

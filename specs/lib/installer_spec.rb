require_relative('../../lib/installer')

describe Installer do
  let(:elastic_search_name) { 'elasticsearch-0.18.4' }
  let(:elastic_install_dir) { File.expand_path(File.join('~', elastic_search_name)) }
  let(:elastic_install_path) { File.expand_path('~') }

  before do
    subject.stub(:`).with("which java").and_return('/usr/bin/java')
    File.stub(:exists?).with(elastic_install_dir).and_return false
  end

  context "when valid" do
    let(:root_path) { File.expand_path(File.join(__FILE__, '..', '..', '..')) }
    let(:elastic_search_tar_path) { File.join(root_path, 'vendor', "#{elastic_search_name}.tar.gz") }
    let(:tmp_path) { File.join(root_path, 'tmp') }

    describe "executing the install" do
      before do
        Kernel.stub(:system)
        FileUtils.stub(:mkdir_p => nil, :mv => nil, :rm_r => nil)
        File.stub(:directory?).with(tmp_path).and_return(false)
      end

      context "when the tmp directory does exist" do
        before do
          File.stub(:directory?).with(tmp_path).and_return(true)
        end

        it 'does not create the tmp directory' do
          FileUtils.should_not_receive(:mkdir_p).with(tmp_path)
          subject.call
        end
      end

      it 'creates the tmp directory' do
        FileUtils.should_receive(:mkdir_p).with(tmp_path)
        subject.call
      end

      it 'unpacks the elastic archive into the tmp directory' do
        Kernel.should_receive(:system).with("cd #{tmp_path}; tar xzf #{elastic_search_tar_path}")
        subject.call
      end

      it 'moves elastic search into the home directory' do
        FileUtils.should_receive(:mv).with("#{tmp_path}/#{elastic_search_name}", elastic_install_path)
        subject.call
      end

      it 'removes the tmp directory' do
        FileUtils.should_receive(:rm_r).with(tmp_path)
        subject.call
      end
    end
  end

  context "when java is not installed" do
    before do
      subject.stub(:`).with("which java").and_return('      ')
    end

    it 'adds an error message' do
      subject.valid?
      subject.error_messages.should == ["Java is not installed. You must have java installed to install Elastic Search."]
    end

    it 'is invalid' do
      subject.should_not be_valid
    end
  end

  context "when java is installed" do
    before do
      subject.stub(:`).with("which java").and_return('/usr/bin/java')
    end

    it 'does not add an error message' do
      subject.valid?
      subject.error_messages.should be_empty
    end

    it 'is valid' do
      subject.should be_valid
    end
  end

  context "when elastic search seems to already be installed" do
    before do
      File.stub(:exists?).with(elastic_install_dir).and_return true
    end

    it 'adds an error message' do
      subject.valid?
      subject.error_messages.should == ["Elastic search seems to already be installed at #{elastic_install_dir}, please run the uninstall command before continuing."]
    end

    it 'is invalid' do
      subject.should_not be_valid
    end
  end

  context "when elastic search is not installed" do
    before do
      File.stub(:exists?).with(elastic_install_dir).and_return false
    end

    it 'does not add an error message' do
      subject.valid?
      subject.error_messages.should be_empty
    end

    it 'is valid' do
      subject.should be_valid
    end
  end

  context "when java is not installed and elastic search is already installed" do
    before do
      subject.stub(:`).with("which java").and_return('     ')
      File.stub(:exists?).with(elastic_install_dir).and_return true
    end

    it 'adds both error messages' do
      subject.valid?
      subject.error_messages.should =~ ["Java is not installed. You must have java installed to install Elastic Search.", "Elastic search seems to already be installed at #{elastic_install_dir}, please run the uninstall command before continuing."]
    end

    it 'is not valid' do
      subject.should_not be_valid
    end
  end
end
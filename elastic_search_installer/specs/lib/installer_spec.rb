require_relative('../../lib/installer')

describe Installer do
  let(:elastic_install_dir) { File.expand_path(File.join('~', 'elasticsearch-0.18.4')) }

  before do
    Kernel.stub(:system).with("java -version").and_return true
    File.stub(:exists?).with(elastic_install_dir).and_return false
  end

  context "when java is not installed" do
    before do
      Kernel.stub(:system).with("java -version").and_return false
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
      Kernel.stub(:system).with("java -version").and_return true
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
      Kernel.stub(:system).with("java -version").and_return false
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
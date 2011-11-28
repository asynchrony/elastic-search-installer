require_relative('../../lib/installer')

Uninstaller = Class.new unless Kernel.const_defined?('Uninstaller')

shared_examples_for 'a successful installation' do
  context "when the tmp directory exists" do
    before do
      File.stub(:directory?).with(Installer.tmp_path).and_return(true)
    end

    it 'does not create the tmp directory' do
      FileUtils.should_not_receive(:mkdir_p).with(Installer.tmp_path)
      subject.call
    end
  end

  it 'creates the tmp directory' do
    FileUtils.should_receive(:mkdir_p).with(Installer.tmp_path)
    subject.call
  end

  it 'unpacks the elastic search archive into the tmp directory' do
    Kernel.should_receive(:system).with("cd #{Installer.tmp_path}; tar xzf #{Installer.elastic_search_tar_path}")
    subject.call
  end

  it 'moves elastic search into the home directory' do
    FileUtils.should_receive(:mv).with("#{Installer.tmp_path}/#{Installer.elastic_search_name}", Installer.elastic_install_path)
    subject.call
  end

  it 'removes the tmp directory' do
    FileUtils.should_receive(:rm_r).with(Installer.tmp_path)
    subject.call
  end

  it 'starts elastic search' do
    Kernel.should_receive(:system).with("#{Installer.elastic_install_dir}/bin/elasticsearch")
    subject.call
  end
end

describe Installer do
  let(:mock_uninstaller) { mock 'uninstaller', :call => nil }

  subject { Installer.new({:f => false, :force => false}) }

  before do
    Uninstaller.stub(:elastic_search_installed? => false, :new => mock_uninstaller)
    Installer.stub(:`).with("which java").and_return('/usr/bin/java')
    Kernel.stub(:system)
    FileUtils.stub(:mkdir_p => nil, :mv => nil, :rm_r => nil)
    File.stub(:directory?).with(Installer.tmp_path).and_return(false)
  end

  context "when valid" do
    it_behaves_like 'a successful installation'
  end

  context "when java is not installed" do
    before do
      Installer.stub(:`).with("which java").and_return('      ')
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
      Installer.stub(:`).with("which java").and_return('/usr/bin/java')
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
      Uninstaller.stub(:elastic_search_installed? => true)
    end

    it 'adds an error message' do
      subject.valid?
      subject.error_messages.should == ["Elastic search seems to already be installed at #{Installer.elastic_install_dir}, please run with --force."]
    end

    it 'is invalid' do
      subject.should_not be_valid
    end

    describe "installing with the --force switch" do
      subject { Installer.new({:f => true, :force => true}) }

      it 'removes the current installation' do
        mock_uninstaller.should_receive(:call)
        subject.call
      end

      it 'is valid' do
        subject.should be_valid
      end

      it_behaves_like 'a successful installation'
    end
  end

  context "when elastic search is not installed" do
    before do
      Uninstaller.stub(:elastic_search_installed? => false)
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
      Installer.stub(:`).with("which java").and_return('     ')
      Uninstaller.stub(:elastic_search_installed? => true)
    end

    it 'adds both error messages' do
      subject.valid?
      subject.error_messages.should =~ ["Java is not installed. You must have java installed to install Elastic Search.", "Elastic search seems to already be installed at #{Installer.elastic_install_dir}, please run with --force."]
    end

    it 'is not valid' do
      subject.should_not be_valid
    end
  end
end
require_relative('../../lib/uninstaller')

Installer = Class.new unless Kernel.const_defined?('Installer')

describe Uninstaller do
  let(:install_dir) { mock 'a directory where elastic search is installed' }

  before do
    Installer.stub(:elastic_install_dir => install_dir)
    Kernel.stub(:system)
  end

  context "when elastic search is installed" do
    before do
      File.stub(:exists?).with(install_dir).and_return(true)
      FileUtils.stub(:rm_r)
    end

    it 'uninstalls the current install' do
      FileUtils.should_receive(:rm_r).with(install_dir)

      subject.call
    end

    context 'and is already running' do
      it 'stops all running elastic search processes' do
        subject.should_receive(:`).with("ps aux | grep elasticsearch | grep java").and_return 'elasticsearch'
        subject.should_receive(:`).with("kill -9 $(ps aux | grep elasticsearch | grep java | awk '{print $2}')")

        subject.call
      end
    end

    context 'and is not running' do
      it 'does not attempt to stop any running elastic search processes' do
        subject.should_receive(:`).with("ps aux | grep elasticsearch | grep java").and_return ''
        subject.should_not_receive(:`).with("kill -9 $(ps aux | grep elasticsearch | grep java | awk '{print $2}')")

        subject.call
      end

    end

  end

  context "when elastic search is not installed" do
    before do
      File.stub(:exists?).with(install_dir).and_return(false)
    end

    it 'does not attempt to uninstall anything' do
      FileUtils.should_not_receive(:rm_r).with(install_dir)

      subject.call
    end
  end
end
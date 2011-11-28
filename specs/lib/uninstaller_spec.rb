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

    it 'stops any running elastic search processes' do
      Kernel.should_receive(:system).with("kill -9 `ps aux | grep [e]lasticsearch-0.18.4 | awk '{print $2}'`")

      subject.call
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
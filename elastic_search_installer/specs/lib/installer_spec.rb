require_relative('../../lib/installer')

describe Installer do
  context "when java is not installed" do
    before do
      Kernel.stub(:system).with("java -version").and_return false
    end

    it 'adds an error message' do
      subject.valid?
      subject.full_error_messages.should == "Java is not installed. You must have java installed to install Elastic Search."
    end
  end

  context "when java is installed" do
    before do
      Kernel.stub(:system).with("java -version").and_return true
    end

    it 'does not add an error message' do
      subject.valid?
      subject.full_error_messages.should be_nil
    end
  end
end
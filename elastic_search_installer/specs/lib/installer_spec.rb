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
      subject.full_error_messages.should be_nil
    end

    it 'is valid' do
      subject.should be_valid
    end
  end
end
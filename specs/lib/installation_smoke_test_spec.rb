require_relative('../../lib/installation_smoke_test')

describe InstallationSmokeTest do
  let(:mock_connection_request) { mock 'request to elasticsearch' }

  subject { InstallationSmokeTest }

  before do
    Net::HTTP.stub(:get_print)
  end

  it 'connects to the search service' do
    Net::HTTP.should_receive(:get_print).with("localhost", "/", 9200)

    subject.call
  end

  context "when connection is successful" do
    before do
      Net::HTTP.stub(:get_print => '{successful response json}')
    end

    it 'returns true' do
      subject.call.should be_true
    end
  end

  context "when connection is unsuccessful" do
    before do
      Net::HTTP.stub(:get_print).and_raise(Errno::ECONNREFUSED)
    end
    
    it 'returns false' do
      subject.call.should be_false
    end
  end
end
require_relative('../../lib/installation_smoke_test')

describe InstallationSmokeTest do
  let(:mock_connection_request) { mock 'request to elasticsearch' }

  subject { InstallationSmokeTest }

  before do
    Net::HTTP.stub(:get)
    subject.stub(:puts)
  end

  it 'connects to the search service' do
    Net::HTTP.should_receive(:get).with("localhost", "/", 9200)

    subject.call
  end

  context "when connection is successful" do
    before do
      Net::HTTP.stub(:get => '{successful response json}')
    end

    it 'returns true' do
      subject.call.should be_true
    end
  end

  context "when connection is unsuccessful" do
    before do
      Net::HTTP.stub(:get).and_raise(Errno::ECONNREFUSED)
      subject.stub(:sleep)
    end

    it 'retries after 10 seconds' do
      subject.should_receive(:sleep).with(10).once
      subject.call
    end

    it 'returns false' do
      subject.call.should be_false
    end
  end
end
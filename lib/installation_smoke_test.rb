require 'net/http'

class InstallationSmokeTest
  def self.call
    Net::HTTP.get('localhost', '/', 9200)
    true
  rescue Exception => e
    retries ||= 1
    if retries <= 1
      sleep 10
      retries += 1
      retry
    else
      puts "Smoke test failed: #{e.inspect}"
      false
    end
  end
end
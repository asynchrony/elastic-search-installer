require 'net/http'

class InstallationSmokeTest
  def self.call
    Net::HTTP.get('localhost', '/', 9200)
    true
  rescue Exception => e
    puts "Smoke test failed: #{e.inspect}"
    false
  end
end
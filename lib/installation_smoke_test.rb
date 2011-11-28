require 'net/http'

class InstallationSmokeTest
  def self.call
    !!Net::HTTP.get_print('localhost', '/', 9200)
  rescue
    false
  end
end
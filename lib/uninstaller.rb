require 'installer'

class Uninstaller
  def self.elastic_search_installed?
    File.exists?(Installer.elastic_install_dir)
  end

  def call
    FileUtils.rm_r(Installer.elastic_install_dir) if Uninstaller.elastic_search_installed?
  end
end
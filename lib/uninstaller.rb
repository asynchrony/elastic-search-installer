require 'installer'

class Uninstaller
  def self.elastic_search_installed?
    File.exists?(Installer.elastic_install_dir)
  end

  def call
    if Uninstaller.elastic_search_installed?
      stop_current_processes
      FileUtils.rm_r(Installer.elastic_install_dir)
    end
  end

  def stop_current_processes
    if running?
      `kill -9 $(ps aux | grep [e]lasticsearch-0.18.4 | awk '{print $2}')`
    end
  end

  def running?
    !`ps aux | grep [e]lasticsearch-0.18.4`.empty?
  end
end
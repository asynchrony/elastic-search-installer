class Installer
  def self.elastic_install_dir
    File.expand_path(File.join(elastic_install_path, elastic_search_name))
  end

  def self.elastic_search_name
    'elasticsearch-0.18.4'
  end

  def self.java_installed?
    !(`which java`).strip.empty?
  end

  def self.root_path
    File.expand_path(File.join(__FILE__, '..', '..'))
  end

  def self.elastic_install_path
    File.expand_path('~')
  end

  def self.elastic_search_tar_path
    File.join(root_path, 'vendor', "#{elastic_search_name}.tar.gz")
  end

  def self.tmp_path
    File.join(root_path, 'tmp')
  end

  attr_accessor :error_messages, :options

  def initialize(options)
    self.error_messages = []
    self.options = options
  end

  def valid?
    error_messages << "Java is not installed. You must have java installed to install Elastic Search." unless Installer.java_installed?
    unless force_install? || !Uninstaller.elastic_search_installed?
      error_messages << "Elastic search seems to already be installed at #{Installer.elastic_install_dir}, please run the uninstall command before continuing."
    end
    error_messages.empty?
  end

  def call
    Uninstaller.new.call if force_install?
    create_temp_dir
    unpack_tar
    move_elastic_search_to_install_dir
    remove_temp_dir
  end

  private

  def move_elastic_search_to_install_dir
    FileUtils.mv("#{Installer.tmp_path}/#{Installer.elastic_search_name}", Installer.elastic_install_path)
  end

  def force_install?
    options[:force]
  end

  def remove_temp_dir
    FileUtils.rm_r(Installer.tmp_path)
  end

  def create_temp_dir
    FileUtils.mkdir_p Installer.tmp_path unless File.directory?(Installer.tmp_path)
  end

  def unpack_tar
    Kernel.system("cd #{Installer.tmp_path}; tar xzf #{Installer.elastic_search_tar_path}")
  end
end
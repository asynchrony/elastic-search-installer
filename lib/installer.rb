class Installer
  attr_accessor :error_messages

  def initialize
    self.error_messages = []
  end

  def valid?
    error_messages << "Java is not installed. You must have java installed to install Elastic Search." unless java_installed?
    error_messages << "Elastic search seems to already be installed at #{elastic_install_dir}, please run the uninstall command before continuing." if elastic_search_installed?
    error_messages.empty?
  end

  def call
    create_temp_dir
    unpack_tar
    move_elastic_search_to_install_dir
    remove_temp_dir
  end

  private

  def move_elastic_search_to_install_dir
    FileUtils.mv("#{tmp_path}/#{elastic_search_name}", elastic_install_path)
  end

  def remove_temp_dir
    FileUtils.rm_r(tmp_path)
  end

  def create_temp_dir
    FileUtils.mkdir_p tmp_path unless File.directory?(tmp_path)
  end

  def unpack_tar
    Kernel.system("cd #{tmp_path}; tar xzf #{elastic_search_tar_path}")
  end

  def elastic_install_dir
    File.expand_path(File.join('~', elastic_search_name))
  end

  def elastic_search_installed?
    File.exists?(elastic_install_dir)
  end

  def java_installed?
    Kernel.system('java -version')
  end

  def root_path
    File.expand_path(File.join(__FILE__, '..', '..'))
  end

  def elastic_install_path
    File.expand_path('~')
  end

  def elastic_search_name
    'elasticsearch-0.18.4'
  end

  def elastic_search_tar_path
    File.join(root_path, 'vendor', "#{elastic_search_name}.tar.gz")
  end

  def tmp_path
    File.join(root_path, 'tmp')
  end
end
module ConfigFile
  def self.add_cluster_name(install_dir, cluster_name)
    File.open(File.join(install_dir, 'config', 'elasticsearch.yml'), 'a') {|f| f.write("cluster.name: #{cluster_name}") }
  end
end
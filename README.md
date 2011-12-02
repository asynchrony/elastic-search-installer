Elastic Search Installer
========================

Installs Elastic Search as a service

Install elastic search
----------------------

    $ elastic_search_installer install my_cluster

Force Install
-------------

Force install elastic search in my_cluster (first remove installation directory)

    $ elastic_search_installer install --force my_cluster

Help
----

    $ elastic_search_installer help
    $ elastic_search_installer help install

Full process to Install
-----------------------

### Clone the repo

Change to /tmp and clone the repo:

    cd /tmp
    git clone https://github.com/asynchrony/elastic-search-installer.git
    cd elastic-search-installer

### Install elastic search and configure, change 'my_cluster_name' to be the elastic search cluster name of your choice

    bin/elastic_search_installer install my_cluster_name

### Install the init script

Install the init script, so the service starts up on boot:

    # AS ROOT
    cp /tmp/elastic-search-installer/scripts/elasticsearch-init-script.sh /etc/init.d/elasticsearch
    chmod +x /etc/init.d/elasticsearch
    
double check the variables at the top of the init script.  You may need to update some of them.

If running Debian or Ubuntu:

    # AS ROOT
    update-rc.d elasticsearch defaults

If running GENTOO:

    # AS ROOT
    rc-update add elasticsearch default

Otherwise:

    # AS ROOT
    chkconfig --add elasticsearch

### Start Elastic Search

    # AS ROOT
    /etc/init.d/elasticsearch start
    /etc/init.d/elasticsearch status

### Test our installation

run the smoke test:

    # Back to normal user!
    bin/elastic_search_installer test

Make sure the output says that the smoke test passed.


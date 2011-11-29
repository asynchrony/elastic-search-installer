Elastic Search Installer
========================

Installs Elastic Search as a service

Install elastic search

`$ elastic_search_installer install my_cluster`

Force Install
=============

Force install elastic search in my_cluster (first remove installation directory)

`$ elastic_search_installer install --force my_cluster`

Help
====

`$ elastic_search_installer help`
`$ elastic_search_installer help install`

Full process to Install
=======================

Change to /tmp and clone the repo:
``
cd /tmp
git clone https://github.com/asynchrony/elastic-search-installer.git
cd elastic-search-installer
``

install:
``
bin/elastic_search_installer install my_cluster_name
``

Install the init script, so the service starts up on boot:

``
# AS ROOT
cp /tmp/elastic-search-installer/scripts/elasticsearch-init-script.sh /etc/init.d/elasticsearch
chmod +x /etc/init.d/elasticsearch
chkconfig --add elasticsearch
/etc/init.d/elasticsearch start
/etc/init.d/elasticsearch status
``

run the smoke test:
``
# Back to normal user!
bin/elastic_search_installer test
``

Make sure the output says that the smoke test passed.

Clean up after ourselves:
``
cd ~
rm -rf /tmp/elastic-search-installer
``
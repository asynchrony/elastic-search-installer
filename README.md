Elastic Search Installer
========================

Installs Elastic Search as a service

Install elastic search

``$ elastic_search_installer install``

Force Install
=============

Force install elastic search (first remove installation directory)

``$ elastic_search_installer install --force``

Help
====

``$ elastic_search_installer help``
``$ elastic_search_installer help install``

Push up script and install on server
====================================
scp -r elastic-search-installer user@host:.; ssh user@host 'elastic-search-installer/bin/elastic_search_installer install; rm -R elastic-search-installer'
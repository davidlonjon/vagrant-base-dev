# This include and extend statement below should only exists if
# using apache
include:
  - states.www.apache2

local_dev_vhost_apache:
  file:
    - managed
    - source: salt://states/setup/sites/local_dev/etc/apache2/sites-available/local.dev
    - name: /etc/apache2/sites-available/local.dev
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: apache2
      - file: set_local_dev_doc_root

# set_local_dev_doc_root:
#   file:
#     - directory
#     - source: salt://states/setup/sites/local_dev/srv/www/local.dev
#     - makedirs: True
#     - name: /srv/www/local.dev
#     - dir_mode: 0755
#     - mode: 0644

set_local_dev_doc_root:
  file:
    - recurse
    - name: /srv/www/local.dev
    - source: salt://states/setup/sites/local_dev/srv/www/local.dev

set_details_php_page:
  file:
    - managed
    - source: salt://states/setup/sites/local_dev/files/details.php
    - name: /srv/www/local.dev/details.php
    - template: jinja
    - makedirs: True
    - mode: 644
    - defaults:
        mysql_username: {{ "root" if pillar["mysql_server"]["root_username"] is not defined else pillar["mysql_server"]["root_username"] }}
        mysql_password: {{ "root" if pillar["mysql_server"]["root_password"] is not defined else pillar["mysql_server"]["root_password"] }}
        mysql_host: {{ "localhost" if pillar["mysql_server"]["bind_address"] is not defined else pillar["mysql_server"]["bind_address"] }}
        memcached_host: {{ "localhost" if pillar["memcached"]["host"] is not defined else pillar["memcached"]["host"] }}
        memcached_port: {{ "11211" if pillar["memcached"]["port"] is not defined else pillar["memcached"]["port"] }}
    - require:
      - file: local_dev_vhost_apache
      - file: set_local_dev_doc_root

local_dev_apache_enable:
  file:
    - symlink
    - name: /etc/apache2/sites-enabled/local.dev
    - target: /etc/apache2/sites-available/local.dev
    - require:
      - file: local_dev_vhost_apache

extend:
  apache2:
    service:
      - running
      - watch:
        - file: /etc/apache2/sites-enabled/local.dev
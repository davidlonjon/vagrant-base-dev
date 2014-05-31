#Install MongoDB (http://www.mongodb.org/)

mongodb_repo:
  pkgrepo:
    - managed
    - humanname: MongoDB PPA
    - name: deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen
    - file: /etc/apt/sources.list.d/mongodb.list
    - keyid: 7F0CEB10
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: mongodb
      - service: mongod

mongodb:
  pkg:
    - installed
    - name: mongodb-org
    - pkgrepo: mongodb_repo

mongod:
  service:
    - running
    - enable: true
    - name: mongod
    - require:
      - pkg: mongodb
      - pkgrepo: mongodb_repo
      - file: set_mongodb_logs_directory

set_mongodb_logs_directory:
  file:
    - directory
    - name: {{ '/var/log/mongodb'  if pillar['mongodb']['logs_base_dir'] is not defined else pillar['mongodb']['logs_base_dir'] }}
    - makedirs: True

/etc/mongodb.conf:
  file:
    - managed
    - source: salt://states/dbs/mongodb/etc/mongodb.conf
    - name: /etc/mongod.conf
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - defaults:
       bind_ip: {{ '127.0.0.1'  if pillar['mongodb']['bind_ip'] is not defined else pillar['mongodb']['bind_ip'] }}
       port: {{ '27017'  if pillar['mongodb']['port'] is not defined else pillar['mongodb']['port'] }}
       logs_base_dir: {{ '/var/log/mongodb'  if pillar['mongodb']['logs_base_dir'] is not defined else pillar['mongodb']['logs_base_dir'] }}
    - require:
      - pkg: mongodb
    - watch_in:
      - service: mongod


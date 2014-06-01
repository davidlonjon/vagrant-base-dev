# Provision MySQL (http://www.mysql.com/)
# Inspired from https://github.com/tony/salt-states-configs

# Install MySQL from package and setup service
mysql-server:
  pkg:
    - installed
    - name: {{ 'mysql-server' if pillar['mysql_server']['version'] is not defined else 'mysql-server-%s' % pillar['mysql_server']['version'] }}
  service:
    - running
    - name: mysql
    - require:
      - pkg: mysql-server

# Setup MySQL root user
mysql-db:
  mysql_user:
    - present
    - name: {{ 'root' if pillar['mysql_server']['root_username'] is not defined else pillar['mysql_server']['root_username'] }}
    - password: {{ 'root' if pillar['mysql_server']['root_password'] is not defined else pillar['mysql_server']['root_password'] }}
    - host: localhost
    - require:
      - pkg: mysql-client
      - service: mysql

# Setup /etc/mysql/my.cnf file
/etc/mysql/my.cnf:
  file:
    - managed
    - name: /etc/mysql/my.cnf
    - source: salt://states/dbs/mysql/etc/mysql/my.cnf
    - template: jinja
    - mode: 644
    - require:
        - pkg: mysql-server
    - defaults:
        port: {{ '3306' if pillar['mysql_server']['port'] is not defined else pillar['mysql_server']['port'] }}
        bind_address: {{ '127.0.0.1' if pillar['mysql_server']['bind_address'] is not defined else pillar['mysql_server']['bind_address'] }}

# Setup /etc/mysql/conf.d directory
/etc/mysql/conf.d:
  file:
    - directory
    - name: /etc/mysql/conf.d
    - dir_mode: 0755
    - mode: 0644

# Setup /etc/mysql/conf.d/server-encoding-and-collation.cnf file
/etc/mysql/conf.d/server-encoding-and-collation.cnf:
  file:
    - managed
    - name: /etc/mysql/conf.d/server-encoding-and-collation.cnf
    - mode: 0644
    - source: salt://states/dbs/mysql/etc/mysql/conf.d/server-encoding-and-collation.cnf
    - require:
      - pkg: mysql-server
    - watch_in:
      - service: mysql-server
    - require_in:
      - file: /etc/mysql/conf.d

# Setup /etc/mysql/conf.d/default-table-engine.cnf file
/etc/mysql/conf.d/default-table-engine.cnf:
  file:
    - managed
    - name: /etc/mysql/conf.d/default-table-engine.cnf
    - mode: 0644
    - source: salt://states/dbs/mysql/etc/mysql/conf.d/default-table-engine.cnf
    - require:
      - pkg: mysql-server
    - watch_in:
      - service: mysql-server
    - require_in:
      - file: /etc/mysql/conf.d

# Install MySQL database connector for python from package
python-mysqldb:
  pkg:
    - installed
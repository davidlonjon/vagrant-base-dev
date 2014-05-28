phppgadmin:
  pkg:
    - installed
    - name: phppgadmin
    - require:
      - pkg: php5
      - pkg: apache2

set_phppgadmin_vhost_file:
  file:
    - managed
    - source: salt://states/tools/phppgadmin/etc/apache2/sites-available/phppgadmin
    - name: /etc/apache2/sites-available/phppgadmin.local.dev
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - defaults:
       server_name: {{ 'phppgadmin.local.dev' if pillar['phppgadmin']['server_name'] is not defined else pillar['phppgadmin']['server_name'] }}
       server_admin: {{ 'admin@local.dev' if pillar['phppgadmin']['server_admin'] is not defined else pillar['phppgadmin']['server_admin'] }}
       allow_from: {{ '127.0.0.1' if pillar['phppgadmin']['allow_from'] is not defined else pillar['phppgadmin']['allow_from'] }}
       logs_dir: {{ '/srv/logs/apache2' if pillar['phppgadmin']['logs_dir'] is not defined else pillar['phppgadmin']['logs_dir'] }}
    - require:
      - pkg: phppgadmin
      - pkg: apache2

enable_phppgadmin_vhost:
  file:
    - symlink
    - name: /etc/apache2/sites-enabled/phppgadmin.local.dev
    - target: /etc/apache2/sites-available/phppgadmin.local.dev
    - require:
      - file: set_phppgadmin_vhost_file
    - watch_in:
      - service: apache2

set_phppgadmin_config_file:
  file:
    - managed
    - source: salt://states/tools/phppgadmin/etc/phppgadmin/config.inc.php
    - name: /etc/phppgadmin/config.inc.php
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - require:
      - pkg: phppgadmin
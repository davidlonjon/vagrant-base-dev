phpmyadmin:
  pkg:
    - installed
    - name: phpmyadmin
    - require:
      - pkg: php5
      - pkg: apache2

phpmyadmin_apache:
  file:
    - managed
    - source: salt://states/tools/phpmyadmin/etc/apache2/sites-available/phpmyadmin
    - name: /etc/apache2/sites-available/phpmyadmin.local.dev
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - defaults:
       server_name: {{ "phpmyadmin.local.dev" if pillar['phpmyadmin']['server_name'] is not defined else pillar['phpmyadmin']['server_name'] }}
       server_admin: {{ "admin@local.dev" if pillar['phpmyadmin']['server_admin'] is not defined else pillar['phpmyadmin']['server_admin'] }}
       allow_from: {{ "127.0.0.1" if pillar['phpmyadmin']['allow_from'] is not defined else pillar['phpmyadmin']['allow_from'] }}
       logs_dir: {{ "/home/vagrant" if pillar['phpmyadmin']['logs_dir'] is not defined else pillar['phpmyadmin']['logs_dir'] }}
    - require:
      - pkg: phpmyadmin
      - pkg: apache2

phpmyadmin_apache-enable:
  file:
    - symlink
    - name: /etc/apache2/sites-enabled/phpmyadmin.local.dev
    - target: /etc/apache2/sites-available/phpmyadmin.local.dev
    - require:
      - file: phpmyadmin_apache
    - watch_in:
      - service: apache2
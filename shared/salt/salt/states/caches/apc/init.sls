install_php_apc:
  pkg:
    - installed
    - name: php-apc
    - require:
      - pkg: setup_php5

set_apc_ini:
  file:
    - managed
    - source: salt://states/caches/apc/etc/php5/conf.d/apc.ini
    - name: /etc/php5/conf.d/apc.ini
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - defaults:
       memory: {{ '32'  if pillar['apc']['memory'] is not defined else pillar['apc']['memory'] }}
    - require:
      - pkg: install_php_apc
    - watch_in:
      - service: apache2
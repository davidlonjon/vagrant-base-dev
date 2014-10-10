nginx:
  pkg:
    - installed
  service:
    - running
    - watch:
      - pkg: nginx
    - require:
        - file: set_nginx_default_site

set_nginx_default_site:
  file:
    - managed
    - source: salt://states/www/nginx/etc/nginx/sites-available/default
    - name: /etc/nginx/sites-available/default
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - defaults:
       port: {{ '8080' if pillar['nginx']['port'] is not defined else pillar['nginx']['port'] }}
    - require:
      - pkg: nginx

nginx_default_site_enable:
  cmd:
    - run
    - name: 'ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default'
    - user: root
    - group: root
    - unless: test -e /etc/nginx/sites-enabled/default
    - require:
      - file: set_nginx_default_site
  # file:
  #   - symlink
  #   - name: /etc/nginx/sites-available/default
  #   - target: /etc/nginx/sites-enabled/default
  #   - unless: test -L /etc/nginx/sites-enabled/default
  #   - require:
  #     - file: set_nginx_default_site

extend:
  nginx:
    service:
      - running
      - watch:
        - file: set_nginx_default_site
include:
  - states.www.apache2

php5:
  pkg:
  - installed
  - pkgs:
    - php5
    - php5-mysql
    - php5-cli
    - php5-dev
    - php5-gd
    - php5-curl
    - php-pear
    - php5-mcrypt
    - php5-intl
    - php5-xdebug
  - require:
    - pkg: apache2
    - pkg: mysql-server

xdebug.ini:
  file:
    - managed
    - source: salt://states/lang/php5/etc/php5/conf.d/xdebug.ini
    - name: /etc/php5/conf.d/xdebug.ini
    - template: jinja
    - mode: 644
    - require:
      - pkg: php5

extend:
  apache2:
    service:
      - running
      - watch:
        - file: xdebug.ini

enable_php5_mcrypt:
  cmd:
    - run
    - name: 'sudo php5enmod mcrypt'
    - cwd: /home/vagrant
    - unless: test -e /etc/php5/conf.d/mcrypt.ini
    - watch_in:
      - service: apache2

/etc/php5/apache2/php.ini:
  file:
    - managed
    - source: salt://states/lang/php5/etc/php5/apache2/php.ini
    - template: jinja
    - mode: 644
    - require:
        - pkg: php5
    - defaults:
        php_upload_max_filesize: {{ "2M" if pillar["php"]["php_upload_max_filesize"] is not defined else pillar["php"]["php_upload_max_filesize"] }}
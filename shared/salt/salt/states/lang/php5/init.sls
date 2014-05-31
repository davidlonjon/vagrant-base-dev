setup_php5:
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
    - php5-imagick
    - imagemagick
  - require:
    - pkg: apache2

set_xdebug_ini:
  file:
    - managed
    - source: salt://states/lang/php5/etc/php5/conf.d/xdebug.ini
    - name: /etc/php5/conf.d/xdebug.ini
    - template: jinja
    - mode: 644
    - require:
      - pkg: setup_php5
    - watch_in:
      - service: apache2

enable_php5_mcrypt:
  cmd:
    - run
    - name: 'sudo php5enmod mcrypt'
    - cwd: /home/vagrant
    - unless: test -e /etc/php5/conf.d/mcrypt.ini
    - watch_in:
      - service: apache2

set_php_ini:
  file:
    - managed
    - source: salt://states/lang/php5/etc/php5/apache2/php.ini
    - name: /etc/php5/apache2/php.ini
    - template: jinja
    - mode: 644
    - require:
        - pkg: setup_php5
    - defaults:
        php_upload_max_filesize: {{ "2M" if pillar["php"]["php_upload_max_filesize"] is not defined else pillar["php"]["php_upload_max_filesize"] }}
    - watch_in:
      -service: apache2

# Setup apc module for php5
php-apc:
  pkg:
    - installed
    - name: php-apc
    - require:
      - pkg: setup_php5

# Setup /etc/php5/conf.d/apc.ini used by php5
/etc/php5/conf.d/apc.ini:
  file:
    - managed
    - name: /etc/php5/conf.d/apc.ini
    - source: salt://states/lang/php5/etc/php5/conf.d/apc.ini
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - defaults:
       shm_size: {{ '32M'  if pillar['apc']['shm_size'] is not defined else pillar['apc']['shm_size'] }}
    - require:
      - pkg: php-apc
    - watch_in:
      - service: apache2

# Setup memcached module for php5
php5-memcached:
  pkg:
    - installed
    - name: php5-memcached
  require:
    - pkg: memcached

# Setup memcached.ini used by php5
/etc/php5/conf.d/memcached.ini:
  file:
    - managed
    - source: salt://states/caches/memcached/etc/php5/conf.d/memcached.ini
    - name: /etc/php5/conf.d/memcached.ini
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - require:
      - pkg: memcached
      - pkg: php5-memcached
    - watch_in:
      - service: apache2
      - service: memcached
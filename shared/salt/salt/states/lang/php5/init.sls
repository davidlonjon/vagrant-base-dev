# Provision php5 (http://www.php.net/)

# Install php5 and some modules
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
    - php5-intl
    - php5-imagick
    - imagemagick
  - require:
    - pkg: apache2

# Setup /etc/php5/apache2/php.ini
/etc/php5/apache2/php.ini:
  file:
    - managed
    - source: salt://states/lang/php5/etc/php5/apache2/php.ini
    - name: /etc/php5/apache2/php.ini
    - makedirs: true
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - require:
      - pkg: php5
      - pkg: apache2
    - defaults:
        max_execution_time: {{ '30' if pillar['php']['max_execution_time'] is not defined else pillar['php']['max_execution_time'] }}
        memory_limit: {{ '128M' if pillar['php']['memory_limit'] is not defined else pillar['php']['memory_limit'] }}
        error_reporting: {{ 'E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED' if pillar['php']['error_reporting'] is not defined else pillar['php']['error_reporting'] }}
        display_errors: "{{ Off if pillar['php']['display_errors'] is not defined else pillar['php']['display_errors'] }}"
        display_startup_errors: "{{ Off if pillar['php']['display_startup_errors'] is not defined else pillar['php']['display_startup_errors'] }}"
        track_errors: "{{ Off if pillar['php']['track_errors'] is not defined else pillar['php']['track_errors'] }}"
        upload_max_filesize: {{ '2M' if pillar['php']['upload_max_filesize'] is not defined else pillar['php']['upload_max_filesize'] }}
    - watch_in:
      - service: apache2

# Setup xdebug module for php5
php5-xdebug:
  pkg:
    - installed
    - name: php5-xdebug
    - require:
      - pkg: php5

# Setup /etc/php5/conf.d/xdebug.ini used by php5
/etc/php5/conf.d/xdebug.ini:
  file:
    - managed
    - source: salt://states/lang/php5/etc/php5/conf.d/xdebug.ini
    - name: /etc/php5/conf.d/xdebug.ini
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - require:
      - pkg: php5-xdebug
    - watch_in:
      - service: apache2

# Setup apc module for php5
php-apc:
  pkg:
    - installed
    - name: php-apc
    - require:
      - pkg: php5

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
    - source: salt://states/lang/php5/etc/php5/conf.d/memcached.ini
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

# Setup php5-mcrypt module for php5
php5-mcrypt:
  pkg:
    - installed
    - name: php5-mcrypt
    - require:
      - pkg: php5

# Enable php5_mcrypt module
enable_php5_mcrypt:
  cmd:
    - run
    - name: 'sudo php5enmod mcrypt'
    - cwd: /home/vagrant
    - unless: test -e /etc/php5/conf.d/mcrypt.ini
    - watch_in:
      - service: apache2
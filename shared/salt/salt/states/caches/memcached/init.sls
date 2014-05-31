# Provision memcached (http://memcached.org/)

# Install memcached from package and setup service
memcached:
  pkg:
    - installed
    - name: memcached
  service:
    - name: memcached
    - running
  require:
    - pkg: build-essential

# Setup /etc/memcached.conf file
/etc/memcached.conf:
  file:
    - managed
    - name: /etc/memcached.conf
    - source: salt://states/caches/memcached/etc/memcached.conf
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - defaults:
       memory: {{ "64"  if pillar['memcached']['memory'] is not defined else pillar['memcached']['memory'] }}
       host: {{ "127.0.0.1"  if pillar['memcached']['host'] is not defined else pillar['memcached']['host'] }}
       port: {{ "11211"  if pillar['memcached']['port'] is not defined else pillar['memcached']['port'] }}
    - require:
      - pkg: memcached
    - watch_in:
      - service: memcached
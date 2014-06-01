# Provision Redis (http://redis.io/)

# Add redis package repository
redis_pkgrepo:
  pkgrepo:
    - managed
    - ppa: chris-lea/redis-server
    - require_in:
        - pkg: redis-server

# Install redis from package and setup service
redis-server:
  pkg:
    - installed
    - name: redis-server
  service:
    - running
    - name: redis-server
    - require:
      - pkg: redis-server

# Setup /etc/redis/redis.conf file
/etc/redis/redis.conf:
  file:
    - managed
    - name: /etc/redis/redis.conf
    - source: salt://states/caches/redis/etc/redis/redis.conf
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - defaults:
       bind: {{ '127.0.0.1'  if pillar['redis']['bind'] is not defined else pillar['redis']['bind'] }}
       port: {{ '6376'  if pillar['redis']['port'] is not defined else pillar['redis']['port'] }}
       logs_base_dir: {{ '/var/log/redis'  if pillar['redis']['logs_base_dir'] is not defined else pillar['redis']['logs_base_dir'] }}
    - require:
      - pkg: redis-server
    - watch_in:
      - service: redis-server
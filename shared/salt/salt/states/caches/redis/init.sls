add_redis_server_repo:
    pkgrepo:
    - managed
    - ppa: chris-lea/redis-server
    - require_in:
        - pkg: redis-server

redis-server:
  pkg:
    - installed
  service:
    - name: redis-server
    - running
    - require:
      - pkg: redis-server

manage_redis_conf:
  file:
    - managed
    - source: salt://states/caches/redis/etc/redis/redis.conf
    - name: /etc/redis/redis.conf
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - defaults:
       host: {{ '127.0.0.1'  if pillar['redis']['host'] is not defined else pillar['redis']['host'] }}
       port: {{ '6376'  if pillar['redis']['port'] is not defined else pillar['redis']['port'] }}
       logs_dir: {{ '/var/log/redis'  if pillar['redis']['logs_dir'] is not defined else pillar['redis']['logs_dir'] }}
    - require:
      - pkg: redis-server
    - watch_in:
      - service: redis-server
phpmyadmin:
  server_name: 'phpmyadmin.local.dev'
  server_admin: 'admin@local.dev'
  allow_from: '10.10.10.0/24'
  logs_dir: '/srv/logs/apache2'

phppgadmin:
  server_name: 'phppgadmin.local.dev'
  server_admin: 'admin@local.dev'
  allow_from: '10.10.10.0/24'
  logs_dir: '/srv/logs/apache2'

mysql_server:
  root_username: 'root'
  root_password: 'root'
  bind_address: '127.0.0.1'
  version: '5.5'

postgresql:
  root_username: 'root'
  root_password: 'root'
  test_db_name: 'test'
  bind_address: '10.10.10.0/24'

nginx:
  port: 8181

# Configuration for /etc/php5/apache2/php.ini file
php:
  max_execution_time: 60
  memory_limit: '256M'
  error_reporting: 'E_ALL'
  display_errors: 'On'
  display_startup_errors: 'On'
  track_errors: 'On'
  upload_max_filesize: '500M'

# Configuration for /etc/php5/conf.d/apc.ini file
apc:
  shm_size: '64M'

# Configuration for /etc/memcached.conf file
memcached:
  memory: 128
  host: '127.0.0.1'
  port: 11211
  logs_base_dir: '/srv/logs/memcached'

# Configuration for /etc/redis/redis.conf file
redis:
  bind: '127.0.0.1'
  port: 6379
  logs_base_dir: '/srv/logs/redis'

mongodb:
  bind_ip: '127.0.0.1'
  port: 27017
  logs_base_dir: '/srv/logs/mongodb'

#Timezone settings for Webgrind
timezone: 'Asia/Seoul'
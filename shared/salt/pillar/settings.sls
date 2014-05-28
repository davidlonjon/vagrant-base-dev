phpmyadmin:
  server_name: 'phpmyadmin.local.dev'
  server_admin: 'admin@local.dev'
  allow_from: '10.10.10.0/24'
  logs_dir: '/srv/logs/apache2'

mysql_server:
  root_username: 'root'
  root_password: 'root'
  bind_address: '127.0.0.1'
  version: '5.5'

postgresql:
  listen_address: '*'
  bind_address: '10.10.10.0/24'

nginx:
  port: 8080

php:
  php_upload_max_filesize: '200M'

memcached:
  memory: 128
  host: '127.0.0.1'
  port: 11211

apc:
  memory: 64

#Timezone settings for Webgrind
timezone: 'Asia/Seoul'
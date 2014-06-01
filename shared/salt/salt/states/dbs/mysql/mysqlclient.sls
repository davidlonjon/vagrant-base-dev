# Provision mysql-client (http://dev.mysql.com/doc/refman/5.5/en/programs-client.html)

# Install mysql-client from package
mysql-client:
  pkg:
    - installed
    - name: {{ 'mysql-client' if pillar['mysql-version'] is not defined else 'mysql-client-%s' % pillar['mysql-version'] }}

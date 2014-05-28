postgresql_repo:
  pkgrepo:
    - managed
    - humanname: Postgresql PPA
    - name: deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main
    - file: /etc/apt/sources.list.d/postgresql.list
    - keyid: ACCC4CF8
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: postgresql
      - service: postgresql

postgresql:
  pkg:
    - installed
    - name: postgresql-9.3
    - pkgrepo: postgresql_repo
  service:
  - running
  - enable: true
  - name: postgresql
  - require:
    - pkg: postgresql
    - pkgrepo: postgresql_repo

postgresql-python:
  pkg:
    - installed
    - name: python-psycopg2

manage_pg_hba.conf:
  file:
    - managed
    - name: /etc/postgresql/9.3/main/pg_hba.conf
    - source: salt://states/dbs/postgresql/etc/postgresql/9.3/main/pg_hba.conf
    - template: jinja
    - mode: 644
    - require:
        - pkg: postgresql
    - watch_in:
      - service: postgresql
    - defaults:
        bind_address: {{ '10.10.10.0/24' if pillar['postgresql']['bind_address'] is not defined else pillar['postgresql']['bind_address'] }}

manage_postgresql_conf:
  file:
    - managed
    - name: /etc/postgresql/9.3/main/postgresql.conf
    - source: salt://states/dbs/postgresql/etc/postgresql/9.3/main/postgresql.conf
    - template: jinja
    - mode: 644
    - require:
        - pkg: postgresql
    - watch_in:
      - service: postgresql
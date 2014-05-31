# Install sqlite3 (http://www.sqlite.org/)

setup_sqlite3:
  pkg:
    - installed
    - pkgs:
      - sqlite3
      - libsqlite3-dev
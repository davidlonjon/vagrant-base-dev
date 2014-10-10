# Provision sqlite3 (http://www.sqlite.org/)

# Install sqlite3 and dependencies from package
sqlite3:
  pkg:
    - installed
    - pkgs:
      - sqlite3
      - libsqlite3-dev
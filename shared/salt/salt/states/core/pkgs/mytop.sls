# Provision mytop (http://jeremy.zawodny.com/mysql/mytop/)

# Install mytop from package
mytop:
  pkg:
    - installed
    - require:
      - pgk: perl
      - pgk: mysql-server

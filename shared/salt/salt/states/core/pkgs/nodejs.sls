# Provision nodejs (http://nodejs.org/)

# Add nodejs package repository
nodejs_pkgrepo:
  pkgrepo:
    - managed
    - ppa: chris-lea/node.js
    - require_in:
        - pkg: nodejs

# Install latest nodejs from package
nodejs:
  pkg:
    - latest

# Set /usr/local directory
/usr/local:
  file:
    - directory
    - name: /usr/local
    - user: vagrant
    - group: vagrant
    - recurse:
      - user
      - group
    - require:
      - pkg: nodejs

# Set /home/vagrant/tmp directory
/home/vagrant/tmp:
  file:
    - directory
    - name: /home/vagrant/tmp
    - user: vagrant
    - group: vagrant
    - recurse:
      - user
      - group
    - require:
      - pkg: nodejs
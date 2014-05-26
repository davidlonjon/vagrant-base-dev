nodejs:
    pkgrepo:
    - managed
    - ppa: chris-lea/node.js
    - require_in:
        - pkg: nodejs
    pkg:
        - latest

/usr/local:
  file:
    - directory
    - user: vagrant
    - group: vagrant
    - recurse:
      - user
      - group
    - require:
      - pkg: nodejs

/home/vagrant/tmp:
  file:
    - directory
    - user: vagrant
    - group: vagrant
    - recurse:
      - user
      - group
    - require:
      - pkg: nodejs
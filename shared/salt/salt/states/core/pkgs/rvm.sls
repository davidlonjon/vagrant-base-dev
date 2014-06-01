# Provision rvm (https://rvm.io/)

# Install rvm package dependencies
rvm-deps:
  pkg.installed:
    - names:
      - bash
      - coreutils
      - gzip
      - bzip2
      - gawk
      - sed
      - curl
      - git-core
      - subversion

# Install rvm from script
rvm:
  cmd:
    - run
    - name: '\curl -L https://get.rvm.io | bash -s stable '
    - cwd: /home/vagrant
    - user: vagrant
    - group: vagrant
    - unless: /home/vagrant/.rvm/bin/rvm -v >/dev/null
    - require:
        - pkg: rvm-deps

# Source rvm
source_rvm:
  cmd:
    - run
    - name: 'source /home/vagrant/.rvm/scripts/rvm'
    - cwd: /home/vagrant
    - require:
        - cmd: rvm
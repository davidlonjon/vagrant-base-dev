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

source_rvm:
    cmd:
        - run
        - name: 'source /home/vagrant/.rvm/scripts/rvm'
        - cwd: /home/vagrant
        - require:
            - cmd: rvm

# This is not needed as ruby 1.9.3 is already installed on Ubuntu 14.04
# ruby:
#   pkg.installed:
#     - name: ruby1.9.3
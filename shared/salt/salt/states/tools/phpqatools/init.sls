install_phpqatools:
  cmd:
    - run
    - name: 'composer global require h4cc/phpqatools:* --dev'
    - cwd: /home/vagrant
    - user: vagrant
    - group: vagrant
    - unless: test -e /home/vagrant/.composer/vendor/bin/phpunit
    - require:
      - cmd: install_composer
      - cmd: create_composer_home

symlink_dbunit:
  cmd:
    - run
    - name: 'ln -s ~/.composer/vendor/phpunit/dbunit/composer/bin/dbunit /usr/local/bin/dbunit'
    - cwd: /home/vagrant
    - user: vagrant
    - group: vagrant
    - unless: test -e /usr/local/bin/dbunit
    - require:
      - cmd: install_phpqatools

symlink_pdepend:
  cmd:
    - run
    - name: 'ln -s ~/.composer/vendor/pdepend/pdepend/src/bin/pdepend /usr/local/bin/pdepend'
    - cwd: /home/vagrant
    - user: vagrant
    - group: vagrant
    - unless: test -e /usr/local/bin/pdepend
    - require:
      - cmd: install_phpqatools

symlink_phpcpd:
  cmd:
    - run
    - name: 'ln -s ~/.composer/vendor/sebastian/phpcpd/phpcpd /usr/local/bin/phpcpd'
    - cwd: /home/vagrant
    - user: vagrant
    - group: vagrant
    - unless: test -e /usr/local/bin/phpcpd
    - require:
      - cmd: install_phpqatools

symlink_php_codesniffer:
  cmd:
    - run
    - name: 'ln -s ~/.composer/vendor/squizlabs/php_codesniffer/scripts/phpcs /usr/local/bin/php_codesniffer'
    - cwd: /home/vagrant
    - user: vagrant
    - group: vagrant
    - unless: test -e /usr/local/bin/php_codesniffer
    - require:
      - cmd: install_phpqatools

symlink_php_cs_fixer:
  cmd:
    - run
    - name: 'ln -s ~/.composer/vendor/fabpot/php-cs-fixer/php-cs-fixer /usr/local/bin/php-cs-fixer'
    - cwd: /home/vagrant
    - user: vagrant
    - group: vagrant
    - unless: test -e /usr/local/bin/php-cs-fixer
    - require:
      - cmd: install_phpqatools

symlink_phploc:
  cmd:
    - run
    - name: 'ln -s ~/.composer/vendor/phploc/phploc/phploc /usr/local/bin/phploc'
    - cwd: /home/vagrant
    - user: vagrant
    - group: vagrant
    - unless: test -e /usr/local/bin/phploc
    - require:
      - cmd: install_phpqatools

symlink_phpmd:
  cmd:
    - run
    - name: 'ln -s ~/.composer/vendor/phpmd/phpmd/src/bin/phpmd /usr/local/bin/phpmd'
    - cwd: /home/vagrant
    - user: vagrant
    - group: vagrant
    - unless: test -e /usr/local/bin/phpmd
    - require:
      - cmd: install_phpqatools

symlink_phpunit:
  cmd:
    - run
    - name: 'ln -s ~/.composer/vendor/phpunit/phpunit/phpunit /usr/local/bin/phpunit'
    - cwd: /home/vagrant
    - user: vagrant
    - group: vagrant
    - unless: test -e /usr/local/bin/phpunit
    - require:
      - cmd: install_phpqatools

symlink_security_checker:
  cmd:
    - run
    - name: 'ln -s ~/.composer/vendor/sensiolabs/security-checker/security-checker /usr/local/bin/security-checker'
    - cwd: /home/vagrant
    - user: vagrant
    - group: vagrant
    - unless: test -e /usr/local/bin/security-checker
    - require:
      - cmd: install_phpqatools
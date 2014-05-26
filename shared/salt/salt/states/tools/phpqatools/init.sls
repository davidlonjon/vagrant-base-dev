install_phpqatools:
  cmd:
    - run
    - name: 'composer global require h4cc/phpqatools:* --dev'
    - cwd: /home/vagrant
    - unless: test -e ~/.composer/vendor/bin/phpunit
    - require:
      - cmd: install_composer
install_wp_cli:
  cmd:
    - run
    - name: 'curl -kL https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar'
    - cwd: /home/vagrant
    - unless: test -f /usr/local/bin/wp
    - require:
        - pkg: curl
        - pkg: setup_php5

chmod_wp_cli:
  cmd:
      - run
      - name: 'chmod +x wp-cli.phar'
      - cwd: /home/vagrant
      - unless: test -f /usr/local/bin/wp
      - require:
        - cmd: install_wp_cli

cp_wp_cli:
  cmd:
    - run
    - name: 'sudo mv wp-cli.phar /usr/local/bin/wp'
    - cwd: /home/vagrant
    - unless: test -f /usr/local/bin/wp
    - require:
        - cmd: install_wp_cli
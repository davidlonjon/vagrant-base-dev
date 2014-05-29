install_composer:
    cmd:
        - run
        - name: 'curl -sS https://getcomposer.org/installer | php'
        - user: vagrant
        - group: vagrant
        - cwd: /home/vagrant
        - unless: test -e /usr/local/bin/composer
        - require:
            - pkg: setup_php5
            - pkg: curl

mv_composer:
    cmd:
        - run
        - name: 'mv composer.phar /usr/local/bin/composer'
        - user: vagrant
        - group: vagrant
        - cwd: /home/vagrant
        - unless: test -e /usr/local/bin/composer
        - require:
            - cmd: install_composer

create_composer_home:
    cmd:
        - run
        - name: 'mkdir /home/vagrant/.composer'
        - user: vagrant
        - group: vagrant
        - cwd: /home/vagrant
        - unless: test -d /home/vagrant/.composer
        - require:
            - cmd: install_composer


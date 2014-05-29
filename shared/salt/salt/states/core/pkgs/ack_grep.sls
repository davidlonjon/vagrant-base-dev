ack-grep:
  pkg:
    - installed

rename_ack_grep:
    cmd:
        - run
        - name: 'sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep'
        - cwd: /home/vagrant
        - unless: test -e /usr/bin/ack
        - require:
            - pkg: ack-grep
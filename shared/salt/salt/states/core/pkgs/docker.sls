docker.io:
  pkg:
    - installed


ln_docker:
    cmd:
        - run
        - name: 'sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker'
        - cwd: /home/vagrant
        - unless: test -e /usr/local/bin/docker
        - require:
            - pkg: docker.io
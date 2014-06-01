# Provision docker (https://www.docker.io/)
# DL: Somehow this is not working on ubuntu precise 64

# Install docker from package
docker.io:
  pkg:
    - installed

# Create docker symlink
create_docker_symlink:
  cmd:
    - run
    - name: 'sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker'
    - cwd: /home/vagrant
    - unless: test -e /usr/local/bin/docker
    - require:
        - pkg: docker.io
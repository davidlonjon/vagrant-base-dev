# Provision virtualenv (http://virtualenv.readthedocs.org/en/latest/)

# Install virtualenv from pip
virtualenv:
  pip.installed:
    - require:
      - pkg: python-pip

# Setup /home/vagrant/.virtualenvs directory
/home/vagrant/.virtualenvs:
  file:
    - directory
    - name: /home/vagrant/.virtualenvs
    - user: vagrant
    - group: vagrant
    - makedirs: True
    - require:
      - pip: virtualenv
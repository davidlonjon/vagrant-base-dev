virtualenv:
  pip.installed:
    - require:
      - pkg: python-pip

/home/vagrant/.virtualenvs:
  file.directory:
    - user: vagrant
    - group: vagrant
    - makedirs: True
    - require:
      - pip: virtualenv
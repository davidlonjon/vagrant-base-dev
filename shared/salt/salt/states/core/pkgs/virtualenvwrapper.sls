virtualenvwrapper:
  pip.installed:
    - require:
      - pkg: python-pip
      - pip: virtualenv
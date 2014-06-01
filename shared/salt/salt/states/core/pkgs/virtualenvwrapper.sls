# Provision virtualenvwrapper (http://virtualenvwrapper.readthedocs.org/en/latest/)

# Install virtualenvwrapper from pip
virtualenvwrapper:
  pip.installed:
    - require:
      - pkg: python-pip
      - pip: virtualenv
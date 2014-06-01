# Provision pip (https://pypi.python.org/pypi/pip)

# Install pip from package
python-pip:
  pkg:
    - installed
    - require:
      - pkg: python

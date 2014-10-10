# Install node pm2(https://github.com/unitech/pm2)

pm2@latest:
  npm.installed:
    - require:
      - pkg: nodejs

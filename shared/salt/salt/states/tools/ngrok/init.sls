# Install ngrok (https://ngrok.com/)
install_ngrok:
    cmd:
        - run
        - name: 'wget -qO- -O ngrok.zip  https://dl.ngrok.com/linux_386/ngrok.zip && unzip ngrok.zip && rm ngrok.zip'
        - cwd: /home/vagrant
        - unless: test -e /usr/local/bin/ngrok
        - require:
            - pkg: wget
            - pkg: unzip

mv_ngrok:
    cmd:
        - run
        - name: 'mv ngrok /usr/local/bin/'
        - cwd: /home/vagrant
        - unless: test -e /usr/local/bin/ngrok
        - require:
            - cmd: install_ngrok
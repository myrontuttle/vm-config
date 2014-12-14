include:
  - postfix

/etc/postfix:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True

/etc/postfix/main.cf:
  file.managed:
    - source: salt://postfix/files/main.cf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix
    - template: jinja

/etc/postfix/sasl_passwd:
  file.managed:
    - source: salt://postfix/files/sasl_passwd
    - user: root
    - group: root
    - mode: 400
    - require:
      - pkg: postfix
    - template: jinja
    - context:
        relayhost: "{{ pillar['postfix']['relayhost'] }}"
        domain: {{ pillar['accounts']['wsodinvestor']['domain'] }}
        username: {{ pillar['accounts']['wsodinvestor']['username'] }}
        password: {{ pillar['accounts']['wsodinvestor']['password'] }}
  cmd.wait:
    - name: postmap /etc/postfix/sasl_passwd
    - user: root
    - watch:
      - file: /etc/postfix/sasl_passwd
    - watch_in:
      - service: postfix

/etc/postfix/cacert.pem:
  cmd.run:
    - name: cat /etc/ssl/certs/Thawte_Premium_Server_CA.pem | sudo tee /etc/postfix/cacert.pem
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix
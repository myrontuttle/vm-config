include:
  - gitlab.openssh-server
  - postfix

gitlab-omnibus.deb:
  file.managed:
    - name: /tmp/gitlab-omnibus.deb
    - source: 
      - salt://gitlab/files/gitlab_7.5.1-omnibus.5.2.0.ci-1_amd64.deb
      - https://downloads-packages.s3.amazonaws.com/ubuntu-14.04/gitlab_7.5.1-omnibus.5.2.0.ci-1_amd64.deb
    - source_hash: md5=FB54F10A08744DF3E4094E7607F7BA8C

gitlab-omnibus:
  cmd.run:
    - name: dpkg -i /tmp/gitlab-omnibus.deb
    - require:
       - file: gitlab-omnibus.deb
       - pkg: openssh-server
       - pkg: postfix

/etc/gitlab/gitlab.rb:
  file.managed:
    - source: salt://gitlab/files/gitlab.rb
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - context:
        ip: {{ salt['network.interfaces']()['eth0']['inet'][0]['address'] }}
    - require:
      - cmd: gitlab-omnibus

gitlab-ctl:
  cmd.run:
    - name: gitlab-ctl reconfigure
    - onchanges:
      - file: /etc/gitlab/gitlab.rb
    - require:
      - cmd: gitlab-omnibus
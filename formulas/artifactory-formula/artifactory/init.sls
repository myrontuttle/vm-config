{% set artifactory = pillar.get('artifactory', {}) -%}
{% set version = artifactory.get('version', '3.4.2') -%}
{% set hash = artifactory.get('hash', '394258c5fc8beffd60de821b6264660f5464b943') -%}

include:
  - java

/tmp/artifactory-install.zip:
  file.managed:
    - source: https://bintray.com/artifact/download/jfrog/artifactory/artifactory-{{ version }}.zip
    - source_hash: sha1={{ hash }}

install:
  cmd.wait:
    - name: unzip /tmp/artifactory-install.zip -d /opt; cd /opt/artifactory-{{ version }}/bin; ./installService.sh
    - watch:
      - file: /tmp/artifactory-install.zip

/opt/artifactory:
  file.symlink:
    - target: /opt/artifactory-{{ version }}

artifactory:
  service.running:
    - enable: True
    - watch:
      - cmd: install
    - require:
      - cmd: java_home
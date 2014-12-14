postfix:
  {% if grains['os'] == 'Ubuntu' %}
  debconf.set:
    - data:
        'postfix/main_mailer_type': {'type': 'select', 'value': 'Internet Site'}
        'postfix/mailname': {'type': 'string', 'value': '{{ grains.id }}'}
  {% endif %}
  pkg.installed:
    - require:
      - debconf: postfix
    - pkgs:
      - postfix
      - mailutils
      - libsasl2-2
      - ca-certificates
      - libsasl2-modules
  service.running:
    - enable: True
    - require:
      - pkg: postfix
    - watch:
      - pkg: postfix

# manage /etc/aliases if data found in pillar
{% if 'aliases' in pillar.get('postfix', '') %}
/etc/aliases:
  file.managed:
    - source: salt://postfix/aliases
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: postfix

run-newaliases:
  cmd.wait:
    - name: newaliases
    - cwd: /
    - watch:
      - file: /etc/aliases
{% endif %}

# manage /etc/postfix/virtual if data found in pillar
{% if 'virtual' in pillar.get('postfix', '') %}
/etc/postfix/virtual:
  file.managed:
    - source: salt://postfix/virtual
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: postfix

run-postmap:
  cmd.wait:
    - name: /usr/sbin/postmap /etc/postfix/virtual
    - cwd: /
    - watch:
      - file: /etc/postfix/virtual
{% endif %}

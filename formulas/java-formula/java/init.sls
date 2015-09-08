{% set java = pillar.get('java', {}) -%}
{% set package = java.get('package', 'default-jdk') -%}
{% set use_jdk = java.get('use_jdk', 'false') -%}
{% set opts = java.get('opts', '') -%}

java:
  pkg.installed:
    - name: {{ package }}

java_home:
  cmd.run:
    {% if use_jdk %}
    - name: echo JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::") >> /etc/environment; export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
    {% else %}
    - name: echo JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::") >> /etc/environment; export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
    {% endif %}
    - require:
      - pkg: {{ package }}

java_opts:
  cmd.run:
    - name: echo JAVA_OPTS="{{ opts }}" >> /etc/environment; export JAVA_OPTS="{{ opts }}"
    - require:
      - pkg: {{ package }}
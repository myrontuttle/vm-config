{% from "jenkins/map.jinja" import jenkins with context %}

include:
  - jenkins

update.jenkins.update.centre:
  cmd.run:
    - name: "curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:{{jenkins.port}}/updateCenter/byId/default/postBack"
    - require:
      - cmd: wait.for.jenkins
      
{% for pluginName in pillar['jenkins']['plugins'] %}

jenkins.plugin.{{ pluginName }}:
  cmd.run:
    - name: java -jar /usr/bin/jenkins-cli.jar -s http://localhost:{{jenkins.port}} install-plugin {{ pluginName }} 
    - watch_in:
      - module: jenkins-restart
    - require:
      - pkg: jenkins
      - file: /usr/bin/jenkins-cli.jar
      - cmd: update.jenkins.update.centre

{% endfor %}

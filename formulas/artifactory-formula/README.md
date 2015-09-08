artifactory-formula
=================

Salt Stack formula for artifactory

This formula is for deploying artifactory to one or more salt minions. 

1. Requires java
2. Downloads Artifactory from Bintray (https://bintray.com/jfrog/artifactory/artifactory/view/general)
- Specify version and hash in pillar
3. Runs service installation
4. Starts service
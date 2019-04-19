FROM jenkins/jenkins:lts-alpine

# Install plugins
COPY ./plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Prepare Configuration
COPY ./jenkins.yaml /var/jenkins_home/casc_configs/jenkins.yaml
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/casc_configs/jenkins.yaml \
    JAVA_OPTS=-Djenkins.install.runSetupWizard=false

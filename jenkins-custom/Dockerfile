FROM jenkins/jenkins:lts

USER root

# Install Docker CLI and required tools
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    git \
    maven \
    sudo \
    lsb-release \
 && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
 && apt-get update && apt-get install -y docker-ce-cli

# Preinstall Jenkins plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN git config --global --add safe.directory /var/jenkins_home/workspace/ci-cd-ecosystem-pipeline

RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt


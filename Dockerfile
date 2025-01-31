# Utiliser l'image officielle de Jenkins comme base
FROM jenkins/jenkins:lts

# Installer les dépendances nécessaires
USER root

# Installer Docker et Docker Compose
RUN apt-get update && \
    apt-get install -y apt-transport-https lsb-release ca-certificates curl gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Installer Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Ajouter l'utilisateur Jenkins au groupe Docker
RUN usermod -aG docker jenkins

# Installer les plugins Jenkins
RUN jenkins-plugin-cli --plugins role-strategy docker-workflow pipeline-github

# Revenir à l'utilisateur Jenkins
USER jenkins

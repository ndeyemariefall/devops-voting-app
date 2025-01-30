# Utiliser l'image officielle de Jenkins comme base
FROM jenkins/jenkins:lts

# Installer les dépendances nécessaires
USER root

# Installer Docker
RUN apt-get update && \
    apt-get install -y apt-transport-https lsb-release ca-certificates curl gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io && \
    apt-get clean

# Ajouter l'utilisateur Jenkins au groupe Docker
RUN usermod -aG docker jenkins

# Install Jenkin plugins
RUN jenkins-plugin-cli --plugins role-strategy

# Revenir à l'utilisateur Jenkins
USER jenkins




FROM node:20

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    wget \
    openjdk-17-jre \
    unzip \
    python3 \
    python3-pip \
    python3-venv \
    ca-certificates \
    && apt-get clean

# Créer et activer un environnement virtuel Python
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Installer le client Python de ZAP
RUN pip install python-owasp-zap-v2.4

# Télécharger et installer ZAP - Version 2.16.1 (lien fixe)
RUN wget https://github.com/zaproxy/zaproxy/releases/download/v2.16.1/ZAP_2.16.1_Linux.tar.gz -O /tmp/zap.tar.gz && \
    mkdir -p /opt/zap && \
    tar -xzf /tmp/zap.tar.gz -C /opt/zap --strip-components=1 && \
    rm /tmp/zap.tar.gz

ENV PATH="/opt/zap:$PATH"

# Déploiement de l'app Node.js
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

CMD ["npm", "start"]

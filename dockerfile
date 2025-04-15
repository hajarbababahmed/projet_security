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

# Installer le client Python de ZAP dans l'environnement virtuel
RUN pip install python-owasp-zap-v2.4

# Télécharger et installer ZAP (version stable)
RUN wget -qO- https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_Linux.tar.gz | \
    tar xvz -C /opt && \
    mv /opt/ZAP_* /opt/zap

ENV PATH="/opt/zap:$PATH"

# Déploiement de l'app Node.js
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

CMD ["npm", "start"]
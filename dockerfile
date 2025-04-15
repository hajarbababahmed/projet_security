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

# Télécharger et installer ZAP - version alternative plus stable
RUN wget https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2.14.0_Linux.tar.gz -O /tmp/zap.tar.gz && \
    mkdir -p /opt/zap && \
    tar -xzf /tmp/zap.tar.gz -C /opt/zap --strip-components=1 && \
    rm /tmp/zap.tar.gz

# Alternative si la version ci-dessus ne fonctionne pas:
# RUN wget https://github.com/zaproxy/zaproxy/releases/latest/download/ZAP_Linux.tar.gz -O /tmp/zap.tar.gz && \
#     mkdir -p /opt/zap && \
#     tar -xzf /tmp/zap.tar.gz -C /opt/zap --strip-components=1 && \
#     rm /tmp/zap.tar.gz

ENV PATH="/opt/zap:$PATH"

# Déploiement de l'app Node.js
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

CMD ["npm", "start"]
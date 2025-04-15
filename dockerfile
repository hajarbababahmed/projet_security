FROM node:20

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    wget \
    openjdk-17-jre \
    unzip \
    python3 \
    python3-pip \
    ca-certificates \
    && apt-get clean

# Installer le client Python de ZAP
RUN pip3 install --break-system-packages python-owasp-zap-v2.4

# Télécharger et exécuter le script d'installation de ZAP
RUN wget --no-check-certificate https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2_14_0_unix.sh && \
    chmod +x ZAP_2_14_0_unix.sh && \
    mkdir -p /opt/zap && \
    ./ZAP_2_14_0_unix.sh -q -dir /opt/zap && \
    rm ZAP_2_14_0_unix.sh

ENV PATH="/opt/zap:$PATH"

# Déploiement de l'app Node.js
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

CMD ["npm", "start"]

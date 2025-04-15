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
RUN pip3 install python-owasp-zap-v2.4

# Télécharger et installer ZAP (version stable actuelle)
RUN wget -qO- https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_Linux.tar.gz | \
    tar xvz -C /opt && \
    mv /opt/ZAP_* /opt/zap

# Alternative si le téléchargement direct échoue:
# RUN wget -qO- https://github.com/zaproxy/zaproxy/releases/latest/download/ZAP_Linux.tar.gz | \
#     tar xvz -C /opt && \
#     mv /opt/ZAP_* /opt/zap

ENV PATH="/opt/zap:$PATH"

# Déploiement de l'app Node.js
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

CMD ["npm", "start"]
FROM node:20

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    wget \
    openjdk-17-jre \
    unzip \
    python3 \
    python3-pip \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Installer le client Python pour ZAP
RUN pip3 install --break-system-packages python-owasp-zap-v2.4

# Télécharger et extraire ZAP avec le bon fichier
RUN wget --no-check-certificate https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2.14.0_Linux.tar.gz && \
    mkdir -p /opt/zap && \
    tar -xvzf ZAP_2.14.0_Linux.tar.gz -C /opt/zap --strip-components=1 && \
    rm ZAP_2.14.0_Linux.tar.gz

# Ajouter ZAP au PATH
ENV PATH="/opt/zap:${PATH}"

# Préparer ton app Node.js
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]

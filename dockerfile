FROM node:20

# Installer les dépendances système nécessaires à ZAP
RUN apt-get update && apt-get install -y \
    wget \
    openjdk-17-jre \
    unzip \
    python3 \
    python3-pip \
    ca-certificates \
    && apt-get clean

# Installer le client Python OWASP ZAP
RUN pip3 install --break-system-packages python-owasp-zap-v2.4

# Télécharger et extraire ZAP dans /opt/zap
RUN wget --no-check-certificate https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2.14.0_unix.tar.gz && \
    mkdir -p /opt/zap && \
    tar -xvzf ZAP_2.14.0_unix.tar.gz -C /opt/zap --strip-components=1 && \
    rm ZAP_2.14.0_unix.tar.gz

ENV PATH="/opt/zap:$PATH"

# Installer l'app Node.js
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

CMD ["npm", "start"]

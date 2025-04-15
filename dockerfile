FROM node:20

# Installer les dépendances nécessaires à ZAP
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget openjdk-17-jre unzip python3 python3-pip ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip3 install --break-system-packages python-owasp-zap-v2.4

# Télécharger et installer ZAP dans /opt/zap
RUN wget https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2_14_0_unix.sh -O zap.sh && \
    chmod +x zap.sh && ./zap.sh -q -dir /opt/zap && rm zap.sh

# Ajouter ZAP au PATH
ENV PATH="/opt/zap:${PATH}"

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]

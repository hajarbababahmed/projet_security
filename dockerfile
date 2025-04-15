FROM node:20

# Installer les dépendances nécessaires pour OWASP ZAP
RUN apt-get update && apt-get install -y \
    default-jre \
    curl \
    && curl -fsSL https://github.com/zaproxy/zaproxy/releases/download/v2.11.1/ZAP_2.11.1_Unix.tar.gz -o /tmp/zap.tar.gz \
    && tar -xvzf /tmp/zap.tar.gz -C /opt \
    && ln -s /opt/ZAP_2.11.1/zap-baseline.py /usr/local/bin/zap-baseline.py

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

# Commande par défaut pour démarrer l'application Node.js
CMD ["npm", "start"]
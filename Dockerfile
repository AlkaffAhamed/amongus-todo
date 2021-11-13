FROM node:7.7.2-alpine
WORKDIR /usr/app
COPY package.json .
RUN npm install --quiet
COPY . .
RUN apt-get -y update && apt-get -y install net-tools curl
ENTRYPOINT [ "npm", "run", "start"]

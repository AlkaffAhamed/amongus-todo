FROM alpine:latest as base
WORKDIR /usr/app
RUN apk add --upgrade nodejs \
  npm
COPY package.json .
RUN npm install --quiet
COPY . .
ENTRYPOINT [ "npm", "run", "start"]

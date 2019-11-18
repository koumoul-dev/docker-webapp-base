FROM node:12.13.0-alpine
MAINTAINER "contact@koumoul.com"

RUN apk add --no-cache curl git
RUN npm i -g npm@latest yarn

# Install node-prune to reduce size of node_modules
RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | sh -s -- -b /usr/local/bin

# Install common packages so that later npm install run faster
ENV NODE_ENV production
WORKDIR /webapp
ADD package.json .
RUN npm install && node-prune
RUN rm package.json package-lock.json

# Default port of our webapps
EXPOSE 8080

# Check the HTTP server is started as health indicator
HEALTHCHECK --start-period=4m --interval=10s --timeout=3s CMD curl -f http://localhost:8080/ || exit 1

CMD ["node", "server"]

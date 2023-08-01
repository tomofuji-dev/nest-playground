#### base ####
# cache our node version for installing later
FROM node:18.3.0-slim as node
FROM ubuntu:focal-20220531 as base
# Avoid running nodejs process as PID 1 (use tini)
RUN apt-get update \
    && apt-get -qq install -y --no-install-recommends \
    tini \
    && rm -rf /var/lib/apt/lists/*

# copy node binaries from node image
COPY --from=node /usr/local/include/ /usr/local/include/
COPY --from=node /usr/local/lib/ /usr/local/lib/
COPY --from=node /usr/local/bin/ /usr/local/bin/
# reset symlinks
RUN corepack disable && corepack enable

# create node user and group, then create app dir
RUN groupadd --gid 1000 node \
    && useradd --uid 1000 --gid node --shell /bin/bash --create-home node \
    && mkdir /app \
    && chown -R node:node /app

WORKDIR /app
USER node
COPY --chown=node:node package*.json yarn*.lock ./
RUN npm ci --only=production && npm cache clean --force

#### dev ####
FROM base as dev
ENV NODE_ENV=development
COPY --chown=node:node . .
RUN npm install --only=development && npm cache clean --force
CMD ["npm", "run", "start:dev"]

#### prod ####
FROM base as prod
ENV NODE_ENV=production
COPY --chown=node:node . .
RUN npm run build
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["npm", "run", "start:prod"]

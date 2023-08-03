#### base ####
# cache our node version for installing later
FROM node:18.3.0-slim as node
FROM ubuntu:focal-20220531 as base
# Avoid running nodejs process as PID 1 (use tini)
RUN apt-get update \
    && apt-get -qq install -y --no-install-recommends \
    tini postgresql-client\
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

#### ci ####
FROM base as ci
RUN npm install --only=development && npm cache clean --force
COPY --chown=node:node . .
RUN chmod +x ./docker/wait-for-postgres.sh ./docker/ci.entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ./docker/wait-for-postgres.sh $DB_HOST ./docker/ci.entrypoint.sh

### builder ###
FROM base as build
RUN npm install --only=development && npm cache clean --force
COPY --chown=node:node . .
RUN npm run build

#### prod ####
FROM base as prod
COPY --chown=node:node --from=build /app/dist ./dist
COPY --chown=node:node ./docker/wait-for-postgres.sh ./wait-for-postgres.sh
RUN chmod +x ./wait-for-postgres.sh

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ./wait-for-postgres.sh $DB_HOST node dist/main

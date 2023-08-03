#!/bin/sh

export PATH="./node_modules/.bin:$PATH"

# 型テスト
tsc --noEmit

# lint
npm run lint

# build
npm run build

# unit test
env-cmd -f ./.env/.env.ci jest

# e2e test
env-cmd -f ./.env/.env.ci jest --config ./test/jest-e2e.json

#!/bin/sh

# 型テスト
tsc --noEmit

# lint
npm run lint

# build
npm run build

# unit test
jest

# e2e test
jest --config ./test/jest-e2e.json

/bin/bash
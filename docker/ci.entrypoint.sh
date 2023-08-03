#!/bin/sh

# いずれかのコマンドが失敗すると、非0のステータスで終了する
set -e

export PATH="./node_modules/.bin:$PATH"

# migration
prisma migrate deploy

# 型テスト
tsc --noEmit

# lint
npm run lint

# unit test
env-cmd -f ./.env/.env.prod jest

# e2e test
env-cmd -f ./.env/.env.prod jest --config ./test/jest-e2e.json

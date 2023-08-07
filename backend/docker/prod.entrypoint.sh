#!/bin/sh

# いずれかのコマンドが失敗すると、非0のステータスで終了する
set -e

# migration
npx prisma migrate deploy

# server start
node dist/src/main

#!/bin/sh

echo '[run-vault] starting vault server...'

exec docker-entrypoint.sh server -dev &
VAULT_PID=$!

cd /app || exit
until vault status > /dev/null; do
    echo '[run-vault] waiting vault server to start'
    sleep 5
done

echo "[run-vault] current directory: $(pwd)"
echo "[run-vault] trying to upload testcontainer to kv secret"
vault kv put secret/spring-boot-service-template @secret.json

if [ $? -eq 0 ]; then
    echo "[run-vault] secret uploaded successfully"
else
    echo "[run-vault] secret uploading failure!"
    kill "$VAULT_PID"
fi

wait
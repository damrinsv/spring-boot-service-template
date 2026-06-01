#!/bin/sh

echo '[run-vault] starting vault server...'

exec docker-entrypoint.sh server -dev &
VAULT_PID=$!

cd /app || exit
until vault status > /dev/null; do
    echo '[run-vault] waiting vault server to start'
    sleep 5
done

echo "[run-vault] enable approle"
vault auth enable approle
vault policy write spring-boot-service-template-policy /vault/config/vault-policy.hcl
vault write auth/approle/role/spring-boot-service-template token_policies="spring-boot-service-template-policy"
vault write auth/approle/role/spring-boot-service-template role_id="db02de05-fa39-4855-059b-67221c5c2f63"
vault write auth/approle/role/spring-boot-service-template/custom-secret-id secret_id="6a174c20-f6de-a53c-74d2-6018fcceff64"

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
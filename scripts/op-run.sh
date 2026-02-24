#!/bin/bash
# ============================================
# Wrapper para correr comandos com 1Password
# ============================================
# Uso: ./scripts/op-run.sh comando
# Exemplo: ./scripts/op-run.sh node script.js
# ============================================

# Carregar service account token
if [ -f "/home/moltbot/.openclaw/workspace/.op-service-account" ]; then
    source /home/moltbot/.openclaw/workspace/.op-service-account
fi

# Verificar se token está configurado
if [ -z "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo "❌ OP_SERVICE_ACCOUNT_TOKEN não configurado"
    echo "Executa primeiro: source .op-service-account"
    exit 1
fi

# Verificar se há comando para executar
if [ $# -eq 0 ]; then
    echo "Uso: ./scripts/op-run.sh <comando>"
    echo "Exemplo: ./scripts/op-run.sh node script.js"
    exit 1
fi

# Correr comando com 1Password
echo "🔐 A carregar secrets do 1Password..."
op run --env-file=/home/moltbot/.openclaw/workspace/.op-env -- "$@"

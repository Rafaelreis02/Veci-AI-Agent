#!/bin/bash

# Backup Diário do Veci/OpenClaw
# Autor: Veci AI Agent
# Data: 2026-02-22
# Descrição: Faz backup diário do workspace para GitHub

set -e

WORKSPACE_DIR="/home/moltbot/.openclaw/workspace"
LOG_FILE="/home/moltbot/.openclaw/workspace/.openclaw/backup.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] Iniciando backup diário..." >> "$LOG_FILE"

cd "$WORKSPACE_DIR"

# Verificar se há alterações
if git diff --quiet && git diff --staged --quiet; then
    echo "[$DATE] Nenhuma alteração para commit." >> "$LOG_FILE"
    exit 0
fi

# Adicionar todas as alterações
git add -A

# Criar commit com timestamp
COMMIT_MSG="Backup diário: $(date '+%Y-%m-%d')

- Estado dos agentes
- Memórias atualizadas
- Documentação
- Configurações"

git commit -m "$COMMIT_MSG" >> "$LOG_FILE" 2>&1 || {
    echo "[$DATE] Erro ao criar commit" >> "$LOG_FILE"
    exit 1
}

# Push para GitHub (se configurado)
if git remote get-url origin > /dev/null 2>&1; then
    git push origin master >> "$LOG_FILE" 2>&1 || {
        echo "[$DATE] Erro ao fazer push" >> "$LOG_FILE"
        exit 1
    }
    echo "[$DATE] Backup concluído e enviado para GitHub!" >> "$LOG_FILE"
else
    echo "[$DATE] Commit local criado (remote não configurado)" >> "$LOG_FILE"
    echo "[$DATE] Para configurar GitHub: git remote add origin <URL>" >> "$LOG_FILE"
fi

echo "[$DATE] Backup concluído com sucesso!" >> "$LOG_FILE"

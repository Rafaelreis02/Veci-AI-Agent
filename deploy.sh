#!/bin/bash
# ============================================
# Deploy Script with 1Password Integration
# ============================================
# Este script carrega secrets do 1Password e faz deploy para Vercel
#
# Uso:
#   ./scripts/deploy.sh [production|preview]
#
# Requisitos:
#   - 1Password CLI instalado (op)
#   - Vercel CLI instalado (vercel)
#   - Autenticado em ambos
# ============================================

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================
# CONFIGURAÇÃO
# ============================================

ENVIRONMENT="${1:-preview}"  # default: preview
VAULT_NAME="VecinoCustom"

if [ "$ENVIRONMENT" = "production" ]; then
    VERCEL_ARGS="--prod"
    SECTION="Production"
    echo -e "${RED}🚨 DEPLOYING TO PRODUCTION${NC}"
else
    VERCEL_ARGS=""
    SECTION="Development"
    echo -e "${BLUE}🚀 Deploying to Preview${NC}"
fi

# ============================================
# VERIFICAÇÕES
# ============================================

echo -e "${BLUE}🔍 Verificando requisitos...${NC}"

# Verificar 1Password CLI
if ! command -v op &> /dev/null; then
    echo -e "${RED}❌ 1Password CLI (op) não encontrado${NC}"
    echo "Instalação: https://developer.1password.com/docs/cli/get-started/"
    exit 1
fi

# Verificar Vercel CLI
if ! command -v vercel &> /dev/null; then
    echo -e "${RED}❌ Vercel CLI não encontrado${NC}"
    echo "Instalação: npm i -g vercel"
    exit 1
fi

# Verificar se está autenticado no 1Password
if ! op whoami &> /dev/null; then
    echo -e "${YELLOW}⚠️  Não autenticado no 1Password${NC}"
    echo "A iniciar signin..."
    op signin
fi

# Verificar se o vault existe
if ! op vault list | grep -q "$VAULT_NAME"; then
    echo -e "${RED}❌ Vault '$VAULT_NAME' não encontrado no 1Password${NC}"
    echo "Cria o vault primeiro e adiciona os secrets."
    exit 1
fi

echo -e "${GREEN}✅ Todos os requisitos satisfeitos${NC}"

# ============================================
# CARREGAR SECRETS
# ============================================

echo -e "${BLUE}🔐 Carregando secrets do 1Password...${NC}"

# Função helper para ler do 1Password
read_secret() {
    local item="$1"
    local field="${2:-password}"
    op read "op://$VAULT_NAME/$SECTION/$item" 2>/dev/null || op read "op://$VAULT_NAME/$item/$field" 2>/dev/null || ""
}

# Carregar secrets
export DATABASE_URL=$(read_secret "DATABASE_URL")
export NEXTAUTH_SECRET=$(read_secret "NEXTAUTH_SECRET")
export NEXTAUTH_URL=$(read_secret "NEXTAUTH_URL")
export APIFY_TOKEN=$(read_secret "APIFY_TOKEN")
export ANTHROPIC_API_KEY=$(read_secret "ANTHROPIC_API_KEY")
export SHOPIFY_STORE_URL=$(read_secret "SHOPIFY_STORE_URL")
export SHOPIFY_CLIENT_ID=$(read_secret "SHOPIFY_CLIENT_ID")
export SHOPIFY_CLIENT_SECRET=$(read_secret "SHOPIFY_CLIENT_SECRET")
export CRON_SECRET=$(read_secret "CRON_SECRET")

# Verificar se os secrets críticos foram carregados
if [ -z "$DATABASE_URL" ]; then
    echo -e "${RED}❌ Falha ao carregar DATABASE_URL${NC}"
    exit 1
fi

if [ -z "$NEXTAUTH_SECRET" ]; then
    echo -e "${RED}❌ Falha ao carregar NEXTAUTH_SECRET${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Secrets carregados com sucesso${NC}"

# ============================================
# BUILD
# ============================================

echo -e "${BLUE}📦 A instalar dependências...${NC}"
npm ci

echo -e "${BLUE}🔨 A fazer build...${NC}"
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build falhou${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build completo${NC}"

# ============================================
# DEPLOY
# ============================================

echo -e "${BLUE}🚀 A fazer deploy...${NC}"

# Deploy para Vercel com as env vars carregadas
# Nota: Vercel CLI pode precisar de --yes para não fazer perguntas
vercel $VERCEL_ARGS --yes

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Deploy completo!${NC}"
    echo ""
    echo -e "${BLUE}📋 Próximos passos:${NC}"
    echo "  1. Verificar logs: vercel logs --all"
    echo "  2. Verificar deployment: vercel --version"
    echo "  3. Testar aplicação"
else
    echo -e "${RED}❌ Deploy falhou${NC}"
    exit 1
fi

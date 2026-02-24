#!/bin/bash
# ============================================
# Setup 1Password for VecinoCustom
# ============================================
# Script interativo para configurar o 1Password Vault
#
# Uso:
#   ./scripts/setup-1password.sh
# ============================================

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║     🔐 Setup 1Password - VecinoCustom Platform        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# ============================================
# VERIFICAR 1PASSWORD CLI
# ============================================

echo -e "${BLUE}🔍 A verificar 1Password CLI...${NC}"

if ! command -v op &> /dev/null; then
    echo -e "${RED}❌ 1Password CLI não instalado${NC}"
    echo ""
    echo "Instalação:"
    echo "  macOS:    brew install 1password-cli"
    echo "  Windows:  winget install AgileBits.1Password.CLI"
    echo "  Linux:    https://developer.1password.com/docs/cli/get-started/"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ 1Password CLI encontrado: $(op --version)${NC}"

# ============================================
# AUTENTICAR
# ============================================

echo ""
echo -e "${BLUE}🔑 A verificar autenticação...${NC}"

if ! op whoami &> /dev/null; then
    echo -e "${YELLOW}⚠️  Não estás autenticado no 1Password${NC}"
    echo ""
    echo "A abrir 1Password para autenticação..."
    op signin
else
    ACCOUNT=$(op whoami --format=json | grep -o '"url":"[^"]*"' | cut -d'"' -f4)
    echo -e "${GREEN}✅ Autenticado como: $ACCOUNT${NC}"
fi

# ============================================
# CRIAR VAULT
# ============================================

echo ""
echo -e "${BLUE}📁 A configurar Vault...${NC}"

VAULT_NAME="VecinoCustom"

if op vault list | grep -q "^$VAULT_NAME$"; then
    echo -e "${GREEN}✅ Vault '$VAULT_NAME' já existe${NC}"
else
    echo -e "${YELLOW}📝 A criar vault '$VAULT_NAME'...${NC}"
    op vault create "$VAULT_NAME"
    echo -e "${GREEN}✅ Vault criado${NC}"
fi

# ============================================
# CRIAR ITEMS
# ============================================

echo ""
echo -e "${BLUE}📝 A criar items no 1Password...${NC}"

create_or_update_item() {
    local item_name="$1"
    local value="$2"
    local section="${3:-Production}"
    
    if op item get "$item_name" --vault="$VAULT_NAME" &> /dev/null; then
        echo "  📝 $item_name já existe"
    else
        echo "  ➕ A criar: $item_name"
        op item create \
            --vault="$VAULT_NAME" \
            --category="password" \
            --title="$item_name" \
            --url="https://vecinocustom.com" \
            password="$value" \
            section="$section" \
            &> /dev/null
    fi
}

# Perguntar valores
ask_value() {
    local prompt="$1"
    local sensitive="${2:-false}"
    
    echo ""
    echo -e "${YELLOW}$prompt${NC}"
    
    if [ "$sensitive" = true ]; then
        read -s value
        echo ""
    else
        read value
    fi
    
    echo "$value"
}

echo ""
echo "============================================"
echo -e "${BLUE}Configuração Production${NC}"
echo "============================================"

# Database
echo ""
DATABASE_URL=$(ask_value "DATABASE_URL (ex: postgresql://user:pass@host/db):")
if [ -n "$DATABASE_URL" ]; then
    create_or_update_item "DATABASE_URL" "$DATABASE_URL" "Production"
fi

# NextAuth
echo ""
NEXTAUTH_SECRET=$(ask_value "NEXTAUTH_SECRET (ou deixar vazio para gerar):")
if [ -z "$NEXTAUTH_SECRET" ]; then
    NEXTAUTH_SECRET=$(openssl rand -base64 32 2>/dev/null || node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
    echo -e "${GREEN}✅ Gerado: ${NEXTAUTH_SECRET:0:20}...${NC}"
fi
create_or_update_item "NEXTAUTH_SECRET" "$NEXTAUTH_SECRET" "Production"

NEXTAUTH_URL=$(ask_value "NEXTAUTH_URL (ex: https://vecinocustom.com):")
if [ -n "$NEXTAUTH_URL" ]; then
    create_or_update_item "NEXTAUTH_URL" "$NEXTAUTH_URL" "Production"
fi

# Shopify (opcional)
echo ""
echo -e "${YELLOW}Queres configurar Shopify? (s/n)${NC}"
read -n 1 -r
if [[ $REPLY =~ ^[Ss]$ ]]; then
    SHOPIFY_STORE=$(ask_value "SHOPIFY_STORE_URL:")
    [ -n "$SHOPIFY_STORE" ] && create_or_update_item "SHOPIFY_STORE_URL" "$SHOPIFY_STORE" "Production"
    
    SHOPIFY_CLIENT_ID=$(ask_value "SHOPIFY_CLIENT_ID:")
    [ -n "$SHOPIFY_CLIENT_ID" ] && create_or_update_item "SHOPIFY_CLIENT_ID" "$SHOPIFY_CLIENT_ID" "Production"
    
    SHOPIFY_CLIENT_SECRET=$(ask_value "SHOPIFY_CLIENT_SECRET (sensitive):" true)
    [ -n "$SHOPIFY_CLIENT_SECRET" ] && create_or_update_item "SHOPIFY_CLIENT_SECRET" "$SHOPIFY_CLIENT_SECRET" "Production"
fi

# APIs (opcional)
echo ""
echo -e "${YELLOW}Queres configurar APIs (Apify, Anthropic)? (s/n)${NC}"
read -n 1 -r
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo ""
    APIFY_TOKEN=$(ask_value "APIFY_TOKEN:" true)
    [ -n "$APIFY_TOKEN" ] && create_or_update_item "APIFY_TOKEN" "$APIFY_TOKEN" "API Keys"
    
    echo ""
    ANTHROPIC_KEY=$(ask_value "ANTHROPIC_API_KEY:" true)
    [ -n "$ANTHROPIC_KEY" ] && create_or_update_item "ANTHROPIC_API_KEY" "$ANTHROPIC_KEY" "API Keys"
fi

# ============================================
# RESUMO
# ============================================

echo ""
echo "============================================"
echo -e "${GREEN}✅ Setup completo!${NC}"
echo "============================================"
echo ""
echo -e "${BLUE}📋 Resumo:${NC}"
echo "  Vault: $VAULT_NAME"
echo ""

# Listar items criados
echo "Items criados:"
op item list --vault="$VAULT_NAME" --format=json | grep -o '"title":"[^"]*"' | cut -d'"' -f4 | while read item; do
    echo "  ✅ $item"
done

echo ""
echo -e "${BLUE}🚀 Próximos passos:${NC}"
echo "  1. Testar: op read 'op://$VAULT_NAME/Production/DATABASE_URL'"
echo "  2. Copiar .env.op para o projeto: cp .env.op.example .env.op"
echo "  3. Correr app: op run --env-file=.env.op -- npm run dev"
echo "  4. Deploy: ./scripts/deploy.sh"
echo ""

#!/bin/bash
# ============================================
# SETUP RÁPIDO 1PASSWORD - VecinoCustom
# ============================================
# Vamos fazer isto juntos, passo a passo
#
# O QUE PRECISAS:
#   1. Conta 1Password (app ou browser)
#   2. Credenciais de acesso
#   3. Secrets do projeto (DATABASE_URL, etc.)
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║     🔐 SETUP 1PASSWORD - VecinoCustom Platform        ║"
echo "║              (Guiado pelo teu Agente IA)              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo ""
echo -e "${BLUE}📋 Este script vai guiar-te passo a passo.${NC}"
echo ""

# ============================================
# PASSO 1: VERIFICAR 1PASSWORD CLI
# ============================================

echo -e "${YELLOW}PASSO 1/5: Verificar 1Password CLI${NC}"
echo "----------------------------------------"

if command -v op &> /dev/null; then
    echo -e "${GREEN}✅ 1Password CLI instalado: $(op --version)${NC}"
else
    echo -e "${RED}❌ 1Password CLI não encontrado${NC}"
    echo ""
    echo "Instalação rápida:"
    echo "  macOS:    brew install 1password-cli"
    echo "  Windows:  winget install AgileBits.1Password.CLI"
    echo "  Ubuntu:   curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg"
    exit 1
fi

echo ""
read -p "Pressiona ENTER para continuar..."

# ============================================
# PASSO 2: AUTENTICAR NO 1PASSWORD
# ============================================

clear
echo -e "${YELLOW}PASSO 2/5: Autenticar no 1Password${NC}"
echo "----------------------------------------"
echo ""
echo "Tens duas opções:"
echo ""
echo -e "${CYAN}Opção A (Recomendada):${NC} Usar 1Password Desktop App"
echo "  1. Abre a app do 1Password no teu computador"
echo "  2. Ativa: Settings > Developer > CLI > 'Connect with 1Password CLI'"
echo "  3. Corre: ${YELLOW}op signin${NC}"
echo ""
echo -e "${CYAN}Opção B:${NC} Adicionar conta manualmente"
echo "  Corre: ${YELLOW}op account add --address my.1password.com --email teu@email.com${NC}"
echo ""

if op whoami &> /dev/null; then
    echo -e "${GREEN}✅ Já estás autenticado!${NC}"
else
    echo -e "${RED}⚠️  Ainda não autenticado${NC}"
    echo ""
    echo -e "${YELLOW}Por favor, autentica-te no 1Password e depois pressiona ENTER${NC}"
    read -p "(Quando estiveres pronto, pressiona ENTER)..."
    
    # Verificar novamente
    if ! op whoami &> /dev/null; then
        echo -e "${RED}❌ Ainda não autenticado. Tenta novamente.${NC}"
        exit 1
    fi
fi

ACCOUNT=$(op whoami --format=json 2>/dev/null | grep -o '"url":"[^"]*"' | cut -d'"' -f4 || echo "Conta ativa")
echo -e "${GREEN}✅ Autenticado: $ACCOUNT${NC}"

echo ""
read -p "Pressiona ENTER para continuar..."

# ============================================
# PASSO 3: CRIAR VAULT
# ============================================

clear
echo -e "${YELLOW}PASSO 3/5: Criar Vault 'VecinoCustom'${NC}"
echo "----------------------------------------"

VAULT_NAME="VecinoCustom"

if op vault list 2>/dev/null | grep -q "^$VAULT_NAME$"; then
    echo -e "${GREEN}✅ Vault '$VAULT_NAME' já existe${NC}"
else
    echo -e "${BLUE}A criar vault '$VAULT_NAME'...${NC}"
    op vault create "$VAULT_NAME"
    echo -e "${GREEN}✅ Vault criado com sucesso!${NC}"
fi

echo ""
read -p "Pressiona ENTER para continuar..."

# ============================================
# PASSO 4: CONFIGURAR SECRETS
# ============================================

clear
echo -e "${YELLOW}PASSO 4/5: Configurar Secrets${NC}"
echo "----------------------------------------"
echo ""
echo "Agora vamos adicionar os secrets ao 1Password."
echo -e "${CYAN}Preciso que me digas os valores (podes copiar do Vercel ou .env)${NC}"
echo ""

add_secret() {
    local name="$1"
    local description="$2"
    local is_sensitive="${3:-false}"
    
    # Verificar se já existe
    if op item get "$name" --vault="$VAULT_NAME" &> /dev/null; then
        echo -e "${GREEN}✅ $name já existe (a saltar)${NC}"
        return
    fi
    
    echo ""
    echo -e "${CYAN}$name${NC}"
    echo "$description"
    
    if [ "$is_sensitive" = "true" ]; then
        echo -e "${YELLOW}(valor não será mostrado)${NC}"
        read -s value
        echo ""  # newline after hidden input
    else
        read value
    fi
    
    if [ -n "$value" ]; then
        op item create \
            --vault="$VAULT_NAME" \
            --category="password" \
            --title="$name" \
            password="$value" \
            notes="$description" \
            &> /dev/null
        echo -e "${GREEN}✅ $name guardado${NC}"
    else
        echo -e "${YELLOW}⏭️  $name saltado (vazio)${NC}"
    fi
}

# Secrets obrigatórios
echo -e "${BLUE}📝 Secrets Obrigatórios:${NC}"
echo "----------------------------------------"

add_secret "DATABASE_URL" \
    "PostgreSQL connection string (ex: postgresql://user:pass@host/db)" \
    true

add_secret "NEXTAUTH_SECRET" \
    "Secret para NextAuth (gera um: https://generate-secret.vercel.app/32)" \
    true

add_secret "NEXTAUTH_URL" \
    "URL da app (ex: https://vecinocustom-influencer-platform.vercel.app)"

# Secrets opcionais
echo ""
echo -e "${BLUE}📝 Secrets Opcionais (podes saltar se quiseres):${NC}"
echo "----------------------------------------"

add_secret "APIFY_TOKEN" \
    "Token do Apify (para scraping TikTok)" \
    true

add_secret "ANTHROPIC_API_KEY" \
    "API Key da Anthropic Claude (para análise AI)" \
    true

add_secret "SHOPIFY_STORE_URL" \
    "URL da loja Shopify (ex: vecinocustom.myshopify.com)"

add_secret "SHOPIFY_CLIENT_ID" \
    "Client ID da app Shopify"

add_secret "SHOPIFY_CLIENT_SECRET" \
    "Client Secret da app Shopify" \
    true

add_secret "CRON_SECRET" \
    "Secret para proteger cron jobs (qualquer string aleatória)" \
    true

echo ""
read -p "Pressiona ENTER para continuar..."

# ============================================
# PASSO 5: TESTAR E FINALIZAR
# ============================================

clear
echo -e "${YELLOW}PASSO 5/5: Verificar Configuração${NC}"
echo "----------------------------------------"

echo ""
echo -e "${BLUE}📊 Resumo:${NC}"
echo "Vault: $VAULT_NAME"
echo ""

# Listar items
echo "Items configurados:"
op item list --vault="$VAULT_NAME" --format=json 2>/dev/null | \
    grep -o '"title":"[^"]*"' | \
    cut -d'"' -f4 | \
    while read item; do
        echo "  ✅ $item"
    done

echo ""
echo -e "${BLUE}🧪 Testar configuração:${NC}"

# Testar ler um secret
if op item get "DATABASE_URL" --vault="$VAULT_NAME" &> /dev/null; then
    echo -e "${GREEN}✅ DATABASE_URL acessível${NC}"
else
    echo -e "${YELLOW}⚠️  DATABASE_URL não configurado${NC}"
fi

echo ""
echo "----------------------------------------"
echo -e "${GREEN}✅ SETUP COMPLETO!${NC}"
echo "----------------------------------------"
echo ""
echo -e "${BLUE}🚀 Próximos passos:${NC}"
echo ""
echo "1. ${YELLOW}Testar:${NC}"
echo "   op read 'op://$VAULT_NAME/DATABASE_URL'"
echo ""
echo "2. ${YELLOW}Criar ficheiro .env.op:${NC}"
echo "   cp .env.op.example .env.op"
echo ""
echo "3. ${YELLOW}Correr app com 1Password:${NC}"
echo "   op run --env-file=.env.op -- npm run dev"
echo ""
echo "4. ${YELLOW}Deploy:${NC}"
echo "   ./scripts/deploy.sh"
echo ""

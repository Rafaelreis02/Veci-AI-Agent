#!/bin/bash
# setup-influencer-agent.sh
# Script de configuração rápida para o Agente Influencers

echo "🎯 Configurando Agente Influencers..."
echo ""

# Verificar se o 1Password CLI está instalado
if ! command -v op &> /dev/null; then
    echo "❌ 1Password CLI não encontrado"
    echo "   Instalar: https://developer.1password.com/docs/cli/get-started/"
    exit 1
fi

echo "✅ 1Password CLI encontrado"

# Verificar se está logado
if ! op whoami &> /dev/null; then
    echo "⚠️  Não está logado no 1Password"
    echo "   A iniciar login..."
    eval $(op signin)
fi

echo "✅ Logado no 1Password"
echo ""

# Buscar credenciais
echo "🔐 A buscar credenciais..."

APIFY_TOKEN=$(op read op://Personal/Apify/credential 2>/dev/null || echo "")
DATABASE_URL=$(op read op://Personal/Neon.tech/DATABASE_URL 2>/dev/null || echo "")
GEMINI_KEY=$(op read op://Personal/Gemini/API_KEY 2>/dev/null || echo "")

# Verificar se conseguimos obter as credenciais
if [ -z "$APIFY_TOKEN" ]; then
    echo "❌ APIFY_API_TOKEN não encontrado no 1Password"
    echo "   Verifica o item 'Apify' no 1Password"
else
    echo "✅ APIFY_API_TOKEN obtido"
    export APIFY_API_TOKEN="$APIFY_TOKEN"
fi

if [ -z "$DATABASE_URL" ]; then
    echo "❌ DATABASE_URL não encontrado no 1Password"
    echo "   Verifica o item 'Neon.tech' no 1Password"
else
    echo "✅ DATABASE_URL obtido"
    export DATABASE_URL="$DATABASE_URL"
fi

if [ -z "$GEMINI_KEY" ]; then
    echo "❌ GEMINI_API_KEY não encontrado no 1Password"
    echo "   Verifica o item 'Google Gemini' no 1Password"
else
    echo "✅ GEMINI_API_KEY obtido"
    export GEMINI_API_KEY="$GEMINI_KEY"
fi

echo ""
echo "📊 Testando conexões..."

# Testar Apify
if [ -n "$APIFY_TOKEN" ]; then
    echo "   🔄 Testando Apify..."
    APIFY_TEST=$(curl -s -H "Authorization: Bearer $APIFY_TOKEN" \
        "https://api.apify.com/v2/acts" | grep -o '"total":' | head -1)
    if [ -n "$APIFY_TEST" ]; then
        echo "   ✅ Apify: Conectado"
    else
        echo "   ❌ Apify: Falha na conexão"
    fi
fi

# Testar Neon (apenas verifica se URL está formatada)
if [ -n "$DATABASE_URL" ]; then
    echo "   🔄 Testando Neon.tech..."
    if [[ "$DATABASE_URL" == *"neon.tech"* ]]; then
        echo "   ✅ Neon: URL válida"
    else
        echo "   ⚠️  Neon: URL parece inválida"
    fi
fi

echo ""
echo "📝 Variáveis de ambiente configuradas:"
echo "   APIFY_API_TOKEN=${APIFY_API_TOKEN:0:20}..."
echo "   DATABASE_URL=${DATABASE_URL:0:50}..."
echo "   GEMINI_API_KEY=${GEMINI_API_KEY:0:20}..."

echo ""
echo "🚀 Pronto para começar as pesquisas!"
echo ""
echo "Comandos úteis:"
echo "   cat PROCESSO_INFLUENCERS.md    # Ver processo completo"
echo "   psql \$DATABASE_URL             # Aceder à base de dados"
echo ""

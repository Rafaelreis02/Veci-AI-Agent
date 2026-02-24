#!/bin/bash
# ============================================
# Setup 1Password Service Account for Veci Agents
# ============================================
# Configura um Service Account para todos os agentes acederem
# sem precisar de autenticação interativa
#
# Uso:
#   ./scripts/setup-1password-service-account.sh
# ============================================

set -e

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  🔐 Setup Service Account 1Password - Veci Agents      ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# ============================================
# PASSO 1: Criar Service Account no 1Password
# ============================================

echo "📋 INSTRUÇÕES PARA O RAFAEL:"
echo ""
echo "1. Abre o 1Password no teu computador"
echo "2. Vai a: https://my.1password.com/serviceaccounts"
echo "3. Clica: 'Create Service Account'"
echo "4. Nome: 'Veci AI Agents'"
echo "5. Escolhe o Vault 'VecinoCustom'"
echo "6. Permissões: 'Read Items' (mínimo necessário)"
echo "7. Copia o token que aparece (começa com 'ops_')"
echo ""
echo "8. Guarda esse token num Secure Note no 1Password"
echo "   Título: 'Service Account - Veci Agents'"
echo ""
echo "Pressiona ENTER quando tiveres o token..."
read

echo ""
echo "📋 PASSO 2: Configurar no servidor"
echo ""

# Verificar se op está instalado
if ! command -v op &> /dev/null; then
    echo "❌ 1Password CLI não está instalado"
    echo "A instalar..."
    
    # Detectar sistema
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
            sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
            sudo tee /etc/apt/sources.list.d/1password.list
        sudo apt update && sudo apt install -y 1password-cli
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install 1password-cli
    fi
    
    echo "✅ 1Password CLI instalado"
fi

echo ""
echo "📋 PASSO 3: Configurar variável de ambiente"
echo ""

cat > /home/moltbot/.openclaw/workspace/.op-service-account << 'EOF'
# ============================================
# 1Password Service Account Token
# ============================================
# Este ficheiro contém o token do Service Account
# para autenticação automática dos agentes
#
# ⚠️ NUNCA commites este ficheiro!
# Já está no .gitignore
# ============================================

# Instruções:
# 1. Copia o token do Service Account
# 2. Substitui abaixo
# 3. Guarda o ficheiro
# 4. Executa: source .op-service-account

export OP_SERVICE_ACCOUNT_TOKEN='COPIAR_TOKEN_AQUI'

# Testar:
# op vault list
# op item list --vault="VecinoCustom"
EOF

echo "✅ Ficheiro de configuração criado: .op-service-account"
echo ""

cat > /home/moltbot/.openclaw/workspace/.op-env << 'EOF'
# ============================================
# Environment Variables via 1Password
# ============================================
# Este ficheiro mapeia secrets para variáveis de ambiente
# Uso: op run --env-file=.op-env -- comando
#
# Formato:
# NOME_VARIAVEL=op://VAULT/ITEM/FIELD
# ============================================

# Notion
NOTION_TOKEN=op://VecinoCustom/Notion/token

# Shopify (quando configurado)
# SHOPIFY_API_KEY=op://VecinoCustom/Shopify/api_key
# SHOPIFY_API_SECRET=op://VecinoCustom/Shopify/api_secret

# APIs (quando configurado)
# OPENAI_API_KEY=op://VecinoCustom/APIs/openai
# ANTHROPIC_API_KEY=op://VecinoCustom/APIs/anthropic

# Outros (adicionar conforme necessário)
EOF

echo "✅ Ficheiro de environment criado: .op-env"
echo ""

# ============================================
# PASSO 4: Criar wrapper script
# ============================================

cat > /home/moltbot/.openclaw/workspace/scripts/op-run.sh << 'EOF'
#!/bin/bash
# ============================================
# Wrapper para correr comandos com 1Password
# ============================================
# Uso: ./scripts/op-run.sh comando
# Exemplo: ./scripts/op-run.sh npm run dev
# ============================================

# Carregar service account token
if [ -f "/home/moltbot/.openclaw/workspace/.op-service-account" ]; then
    source /home/moltbot/.openclaw/workspace/.op-service-account
fi

# Verificar se token está configurado
if [ -z "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo "❌ OP_SERVICE_ACCOUNT_TOKEN não configurado"
    echo "Executa primeiro: ./scripts/setup-1password-service-account.sh"
    exit 1
fi

# Correr comando com 1Password
op run --env-file=/home/moltbot/.openclaw/workspace/.op-env -- "$@"
EOF

chmod +x /home/moltbot/.openclaw/workspace/scripts/op-run.sh

echo "✅ Wrapper script criado: scripts/op-run.sh"
echo ""

# ============================================
# PASSO 5: Testar
# ============================================

echo "📋 PASSO 5: Testar configuração"
echo ""

cat > /home/moltbot/.openclaw/workspace/scripts/test-1password.sh << 'EOF'
#!/bin/bash
# ============================================
# Testar 1Password Service Account
# ============================================

echo "🔍 A testar 1Password..."

# Carregar token
if [ -f "/home/moltbot/.openclaw/workspace/.op-service-account" ]; then
    source /home/moltbot/.openclaw/workspace/.op-service-account
fi

if [ -z "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo "❌ Token não configurado"
    echo "Edita .op-service-account e adiciona o token"
    exit 1
fi

# Testar autenticação
echo "  A verificar autenticação..."
if op vault list &> /dev/null; then
    echo "  ✅ Autenticação OK"
    
    echo ""
    echo "📁 Vaults disponíveis:"
    op vault list
    
    echo ""
    echo "📋 Items no vault VecinoCustom:"
    op item list --vault="VecinoCustom" 2>/dev/null || echo "  (Vault não encontrado ou vazio)"
    
    echo ""
    echo "✅ 1Password configurado com sucesso!"
else
    echo "  ❌ Erro de autenticação"
    echo "  Verifica se o token está correto em .op-service-account"
    exit 1
fi
EOF

chmod +x /home/moltbot/.openclaw/workspace/scripts/test-1password.sh

echo "✅ Script de teste criado: scripts/test-1password.sh"
echo ""

# ============================================
# RESUMO
# ============================================

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  ✅ Setup Completo!                                    ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "📋 PRÓXIMOS PASSOS:"
echo ""
echo "1. Edita: .op-service-account"
echo "   Adiciona o token do Service Account na linha:"
echo "   export OP_SERVICE_ACCOUNT_TOKEN='ops_seu_token_aqui'"
echo ""
echo "2. Testa: ./scripts/test-1password.sh"
echo ""
echo "3. Usa: ./scripts/op-run.sh comando"
echo "   Exemplo: ./scripts/op-run.sh npm run dev"
echo ""
echo "4. Para todos os agentes usarem:"
echo "   - O token fica no .op-service-account"
echo "   - Cada agente pode correr comandos com secrets"
echo "   - Nunca expões secrets em código"
echo ""
echo "🔒 Segurança:"
echo "   - .op-service-account está no .gitignore"
echo "   - Só o Service Account acede ao vault"
echo "   - Permissões mínimas (read only)"
echo ""

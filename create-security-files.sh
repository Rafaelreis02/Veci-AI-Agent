#!/bin/bash
# ============================================
# CRIAR FICHEIROS DE SEGURANÇA NO PROJETO
# ============================================
# Copia e cola isto no terminal do teu projeto
#
# cd vecinocustom-influencer-platform
# bash -c "$(curl -fsSL https://gist.githubusercontent.com/.../raw/setup.sh)"
# ============================================

set -e

echo "🔐 A criar ficheiros de segurança..."

# Criar pasta scripts se não existir
mkdir -p scripts
mkdir -p src/lib

# ============================================
# 1. .env.op (configuração 1Password)
# ============================================
cat > .env.op << 'EOF'
# ============================================
# 1Password Environment File
# ============================================
# Uso: op run --env-file=.env.op -- npm run dev
#
# ⚠️ NUNCA commites este ficheiro!
# ============================================

# Database
DATABASE_URL=op://VecinoCustom/Production/DATABASE_URL

# NextAuth
NEXTAUTH_SECRET=op://VecinoCustom/Production/NEXTAUTH_SECRET
NEXTAUTH_URL=op://VecinoCustom/Production/NEXTAUTH_URL

# Shopify
SHOPIFY_STORE_URL=op://VecinoCustom/Production/SHOPIFY_STORE_URL
SHOPIFY_CLIENT_ID=op://VecinoCustom/Production/SHOPIFY_CLIENT_ID
SHOPIFY_CLIENT_SECRET=op://VecinoCustom/Production/SHOPIFY_CLIENT_SECRET
NEXT_PUBLIC_BASE_URL=op://VecinoCustom/Production/NEXT_PUBLIC_BASE_URL

# Cron
CRON_SECRET=op://VecinoCustom/Production/CRON_SECRET

# APIs
APIFY_TOKEN=op://VecinoCustom/API Keys/APIFY_TOKEN
ANTHROPIC_API_KEY=op://VecinoCustom/API Keys/ANTHROPIC_API_KEY

# Email
GMAIL_CLIENT_SECRET=op://VecinoCustom/API Keys/GMAIL_CLIENT_SECRET
FROM_EMAIL=op://VecinoCustom/API Keys/FROM_EMAIL
EOF

echo "✅ Criado: .env.op"

# ============================================
# 2. src/lib/env.ts (validação TypeScript)
# ============================================
cat > src/lib/env.ts << 'EOF'
/**
 * Environment Variables Validation
 * 
 * Valida e exporta env vars com tipagem TypeScript
 */

const REQUIRED_ENV_VARS = [
  'DATABASE_URL',
  'NEXTAUTH_SECRET',
  'NEXTAUTH_URL',
] as const;

export function validateEnv(): void {
  const missing = REQUIRED_ENV_VARS.filter(
    (key) => !process.env[key]
  );
  
  if (missing.length > 0) {
    throw new Error(
      `❌ Missing environment variables:\n` +
      missing.map((k) => `  - ${k}`).join('\n')
    );
  }
}

export const env = {
  DATABASE_URL: process.env.DATABASE_URL!,
  NEXTAUTH_SECRET: process.env.NEXTAUTH_SECRET!,
  NEXTAUTH_URL: process.env.NEXTAUTH_URL!,
  APIFY_TOKEN: process.env.APIFY_TOKEN,
  ANTHROPIC_API_KEY: process.env.ANTHROPIC_API_KEY,
};
EOF

echo "✅ Criado: src/lib/env.ts"

# ============================================
# 3. scripts/deploy.sh
# ============================================
cat > scripts/deploy.sh << 'EOF'
#!/bin/bash
# Deploy com 1Password
set -e

echo "🔐 A carregar secrets do 1Password..."

export DATABASE_URL=$(op read "op://VecinoCustom/Production/DATABASE_URL")
export NEXTAUTH_SECRET=$(op read "op://VecinoCustom/Production/NEXTAUTH_SECRET")
export APIFY_TOKEN=$(op read "op://VecinoCustom/API Keys/APIFY_TOKEN")

echo "🚀 Deploying..."
vercel --prod
EOF

chmod +x scripts/deploy.sh
echo "✅ Criado: scripts/deploy.sh"

# ============================================
# 4. Actualizar .env.example
# ============================================
cat > .env.example << 'EOF'
# ============================================
# VECINOCUSTOM - Environment Variables
# ============================================
# ⚠️ NUNCA commites valores reais!
# 🔐 Usa 1Password: op run --env-file=.env.op -- npm run dev
# ============================================

# Obrigatório
DATABASE_URL="postgresql://user:pass@host/db"
NEXTAUTH_SECRET="gerar-com-openssl-rand-base64-32"
NEXTAUTH_URL="http://localhost:3000"

# Shopify
SHOPIFY_STORE_URL="loja.myshopify.com"
SHOPIFY_CLIENT_ID=""
SHOPIFY_CLIENT_SECRET=""
NEXT_PUBLIC_BASE_URL="http://localhost:3000"

# APIs
APIFY_TOKEN=""
ANTHROPIC_API_KEY=""
CRON_SECRET=""

# Email
GMAIL_CLIENT_SECRET=""
FROM_EMAIL="brand@vecinocustom.com"
EOF

echo "✅ Actualizado: .env.example"

# ============================================
# 5. Adicionar ao .gitignore
# ============================================
if ! grep -q ".env.op" .gitignore; then
    echo "" >> .gitignore
    echo "# 1Password" >> .gitignore
    echo ".env.op" >> .gitignore
    echo "✅ Adicionado .env.op ao .gitignore"
fi

# ============================================
# RESUMO
# ============================================
echo ""
echo "============================================"
echo "✅ FICHEIROS CRIADOS!"
echo "============================================"
echo ""
echo "Próximos passos:"
echo ""
echo "1. Instalar 1Password CLI:"
echo "   macOS: brew install 1password-cli"
echo ""
echo "2. Autenticar:"
echo "   op signin"
echo ""
echo "3. Criar vault e adicionar secrets:"
echo "   op vault create VecinoCustom"
echo "   op item create --vault=VecinoCustom --title=DATABASE_URL password='postgresql://...'"
echo ""
echo "4. Correr app:"
echo "   op run --env-file=.env.op -- npm run dev"
echo ""
echo "📖 Documentação completa em: SECURITY-README.md"
echo "============================================"
EOF

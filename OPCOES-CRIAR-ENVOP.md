# 🔧 CRIAR .env.op - Opções

## OPÇÃO 1: Eu crio no GitHub (Preciso de token)

**Do que preciso:**
- GitHub Personal Access Token com scope `repo`

**Como criar o token:**
1. Vai a https://github.com/settings/tokens
2. Generate new token (classic)
3. Seleciona: `repo` (acesso total ao repositório)
4. Expiração: 1 dia (ou o que preferires)
5. Copia o token e envia-me (podes apagar depois)

**O que eu faço:**
- Crio o ficheiro `.env.op` com configuração para o vault AI-VECINO
- Faço commit diretamente no main (ou crio PR)

---

## OPÇÃO 2: Comando Copy-Paste (Não precisas de mim)

**Copia isto no terminal do teu projeto:**

```bash
cat > .env.op << 'EOF'
# 1Password Configuration - VecinoCustom
# Vault: AI-VECINO
# Usage: op run --env-file=.env.op -- npm run dev

# Database
DATABASE_URL=op://AI-VECINO/DATABASE_URL

# NextAuth
NEXTAUTH_SECRET=op://AI-VECINO/NEXTAUTH_SECRET
NEXTAUTH_URL=op://AI-VECINO/NEXTAUTH_URL

# APIs
APIFY_TOKEN=op://AI-VECINO/APIFY_TOKEN
ANTHROPIC_API_KEY=op://AI-VECINO/ANTHROPIC_API_KEY

# Shopify
SHOPIFY_STORE_URL=op://AI-VECINO/SHOPIFY_STORE_URL
SHOPIFY_CLIENT_ID=op://AI-VECINO/SHOPIFY_CLIENT_ID
SHOPIFY_CLIENT_SECRET=op://AI-VECINO/SHOPIFY_CLIENT_SECRET

# App
NEXT_PUBLIC_BASE_URL=op://AI-VECINO/NEXT_PUBLIC_BASE_URL
CRON_SECRET=op://AI-VECINO/CRON_SECRET
EOF

echo "✅ Ficheiro .env.op criado!"
```

Depois:
```bash
# Adicionar ao .gitignore se ainda não estiver
echo ".env.op" >> .gitignore

# Testar
op run --env-file=.env.op -- npm run dev
```

---

## OPÇÃO 3: Criar manualmente no VS Code

1. Cria ficheiro `.env.op` na raiz do projeto
2. Cola este conteúdo:

```
DATABASE_URL=op://AI-VECINO/DATABASE_URL
NEXTAUTH_SECRET=op://AI-VECINO/NEXTAUTH_SECRET
NEXTAUTH_URL=op://AI-VECINO/NEXTAUTH_URL
APIFY_TOKEN=op://AI-VECINO/APIFY_TOKEN
ANTHROPIC_API_KEY=op://AI-VECINO/ANTHROPIC_API_KEY
SHOPIFY_STORE_URL=op://AI-VECINO/SHOPIFY_STORE_URL
SHOPIFY_CLIENT_ID=op://AI-VECINO/SHOPIFY_CLIENT_ID
SHOPIFY_CLIENT_SECRET=op://AI-VECINO/SHOPIFY_CLIENT_SECRET
NEXT_PUBLIC_BASE_URL=op://AI-VECINO/NEXT_PUBLIC_BASE_URL
CRON_SECRET=op://AI-VECINO/CRON_SECRET
```

3. Guarda

---

## Qual preferes?

- 🔴 **Opção 1** (Token) - Eu faço tudo, mas preciso de acesso temporário
- 🟡 **Opção 2** (Copy-paste) - 10 segundos no teu terminal
- 🟢 **Opção 3** (Manual) - Crias tu no VS Code

Qual te serve melhor?

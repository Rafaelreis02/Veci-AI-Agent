# 🔐 RELATÓRIO DE SEGURANÇA - VecinoCustom Influencer Platform

**Data:** 2026-02-22  
**Analisado por:** Programador Influencers (Agente IA)  
**Status:** ✅ Sem secrets expostos no código

---

## 📊 Resumo da Auditoria

### ✅ BOM - O que está correto:

| Ficheiro | Avaliação |
|----------|-----------|
| `src/lib/apify.ts` | ✅ Usa `process.env.APIFY_TOKEN` corretamente |
| `.env.example` | ✅ Placeholders genéricos, sem valores reais |
| `.gitignore` | ✅ Inclui `.env` e `.env*.local` |
| `test-*.json` | ✅ Apenas dados de teste, sem secrets |
| `add-influencer.js` | ✅ Sem secrets, apenas dados de exemplo |
| `force_import.js` | ✅ Sem secrets (mas tem URLs hardcoded) |
| `update-status.js` | ✅ Sem secrets |

### ⚠️ ATENÇÃO - Pontos a melhorar:

1. **URLs Hardcoded** em `force_import.js`:
   ```javascript
   const pendingUrl = 'https://vecinocustom-influencer-platform.vercel.app/api/worker/pending';
   // Deveria ser: process.env.API_BASE_URL + '/api/worker/pending'
   ```

2. **Scripts de utilidade** podem ser consolidados e melhorados

3. **Ficheiros de teste JSON** podem ser movidos para pasta `tests/` ou `fixtures/`

---

## 🎯 Plano de Ação com 1Password

### FASE 1: Setup 1Password Vault (Agora)

#### Estrutura recomendada:

```
🔐 VecinoCustom Vault/
├── 📁 Production/
│   ├── DATABASE_URL
│   ├── NEXTAUTH_SECRET
│   ├── NEXTAUTH_URL
│   ├── SHOPIFY_STORE_URL
│   ├── SHOPIFY_CLIENT_ID
│   ├── SHOPIFY_CLIENT_SECRET
│   ├── CRON_SECRET
│   └── NEXT_PUBLIC_BASE_URL
│
├── 📁 Development/
│   ├── DATABASE_URL (dev)
│   ├── NEXTAUTH_SECRET (dev)
│   ├── NEXTAUTH_URL (http://localhost:3000)
│   └── NEXT_PUBLIC_BASE_URL (http://localhost:3000)
│
├── 📁 API Keys/
│   ├── APIFY_TOKEN
│   ├── ANTHROPIC_API_KEY (ou GOOGLE_GEMINI_API_KEY)
│   ├── GMAIL_CLIENT_SECRET
│   └── SENDGRID_API_KEY (se usar)
│
└── 📁 Infrastructure/
    ├── Vercel Token (se necessário para CLI)
    └── AWS credentials (se usar S3)
```

---

### FASE 2: Documentação de Secrets (.env.example atualizado)

```env
# ============================================
# DATABASE
# ============================================
DATABASE_URL="postgresql://user:password@localhost:5432/vecinocustom"

# ============================================
# AUTHENTICATION (NextAuth.js)
# ============================================
NEXTAUTH_SECRET="generate-a-random-secret-here-min-32-chars"
NEXTAUTH_URL="http://localhost:3000"

# ============================================
# SHOPIFY INTEGRATION
# ============================================
SHOPIFY_STORE_URL="your-store.myshopify.com"
SHOPIFY_CLIENT_ID=""
SHOPIFY_CLIENT_SECRET=""
NEXT_PUBLIC_BASE_URL="http://localhost:3000"

# ============================================
# CRON JOBS (Vercel Cron Protection)
# ============================================
CRON_SECRET="generate-a-random-secret-here"

# ============================================
# AI & SCRAPING APIs
# ============================================
APIFY_TOKEN=""
ANTHROPIC_API_KEY=""  # ou GOOGLE_GEMINI_API_KEY

# ============================================
# EMAIL (Gmail OAuth ou SendGrid)
# ============================================
GMAIL_CLIENT_SECRET=""  # Se usar Gmail OAuth
SENDGRID_API_KEY=""     # Se usar SendGrid
FROM_EMAIL="brand@vecinocustom.com"

# ============================================
# FILE STORAGE (AWS S3 / Cloudflare R2)
# ============================================
AWS_S3_BUCKET=""
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
AWS_REGION="eu-west-1"

# ============================================
# SOCIAL MEDIA APIs (Futuro)
# ============================================
TIKTOK_CLIENT_KEY=""
TIKTOK_CLIENT_SECRET=""
INSTAGRAM_APP_ID=""
INSTAGRAM_APP_SECRET=""
```

---

### FASE 3: Uso no Desenvolvimento

#### Opção A: op run (Recomendado)

```bash
# Criar .env.op (não commited, adicionar ao .gitignore)
# Este ficheiro mapeia env vars para 1Password

# .env.op
DATABASE_URL=op://VecinoCustom/Production/DATABASE_URL
NEXTAUTH_SECRET=op://VecinoCustom/Production/NEXTAUTH_SECRET
APIFY_TOKEN=op://VecinoCustom/API Keys/APIFY_TOKEN

# Correr app
op run --env-file=.env.op -- npm run dev
```

#### Opção B: op inject

```bash
# Criar .env a partir de template
op inject -i .env.example -o .env
# (preenche os valores do 1Password no .env)
```

#### Opção C: Scripts de Deploy

```bash
#!/bin/bash
# scripts/deploy.sh
set -e

echo "🔐 Carregando secrets do 1Password..."

export DATABASE_URL=$(op read "op://VecinoCustom/Production/DATABASE_URL")
export NEXTAUTH_SECRET=$(op read "op://VecinoCustom/Production/NEXTAUTH_SECRET")
export APIFY_TOKEN=$(op read "op://VecinoCustom/API Keys/APIFY_TOKEN")
# ... outros secrets

echo "🚀 Deploying to Vercel..."
vercel --prod
```

---

### FASE 4: Melhorias de Código

#### 1. Criar `src/lib/env.ts` (validação de env vars)

```typescript
// src/lib/env.ts
const requiredEnvVars = [
  'DATABASE_URL',
  'NEXTAUTH_SECRET',
  'NEXTAUTH_URL',
] as const;

const optionalEnvVars = [
  'APIFY_TOKEN',
  'ANTHROPIC_API_KEY',
  'SHOPIFY_ACCESS_TOKEN',
] as const;

// Validação em tempo de build
export function validateEnv() {
  const missing = requiredEnvVars.filter(
    (key) => !process.env[key]
  );
  
  if (missing.length > 0) {
    throw new Error(
      `❌ Missing required environment variables:\n` +
      missing.map((key) => `  - ${key}`).join('\n')
    );
  }
}

// Tipagem segura
export const env = {
  DATABASE_URL: process.env.DATABASE_URL!,
  NEXTAUTH_SECRET: process.env.NEXTAUTH_SECRET!,
  NEXTAUTH_URL: process.env.NEXTAUTH_URL!,
  APIFY_TOKEN: process.env.APIFY_TOKEN,
  ANTHROPIC_API_KEY: process.env.ANTHROPIC_API_KEY,
  // ... etc
};
```

#### 2. Atualizar `src/lib/apify.ts`

```typescript
// Adicionar validação
import { env } from './env';

const client = new ApifyClient({
  token: env.APIFY_TOKEN || '',
});

if (!env.APIFY_TOKEN) {
  console.warn('⚠️ APIFY_TOKEN não configurado. Funcionalidade de scraping desativada.');
}
```

#### 3. Consolidar scripts de utilidade

Criar `scripts/` pasta organizada:
```
scripts/
├── README.md
├── db/
│   ├── add-influencer.ts
│   ├── update-status.ts
│   └── migrate-data.ts
├── deploy/
│   └── deploy-with-secrets.sh
└── dev/
    └── setup-local-env.sh
```

---

## 🚀 Checklist de Implementação

### Agora:
- [ ] Criar vault "VecinoCustom" no 1Password
- [ ] Criar items para cada secret
- [ ] Testar `op read` para cada secret
- [ ] Criar `.env.op` para desenvolvimento

### Próximos passos:
- [ ] Atualizar `.env.example` com documentação
- [ ] Criar `src/lib/env.ts` para validação
- [ ] Mover scripts para pasta `scripts/`
- [ ] Documentar processo no README

### Futuro:
- [ ] Git pre-commit hook para verificar secrets
- [ ] GitHub Secret Scanning
- [ ] Rotacionar secrets periodicamente

---

## 📝 Notas

- **Bom trabalho!** Não encontrei secrets expostos no código ✅
- O código já usa `process.env` corretamente
- O `.gitignore` já está configurado
- A integração com 1Password será principalmente para gestão centralizada

---

**Próximo passo:** Queres que eu comece a implementar isto? Posso:
1. Criar o vault no 1Password (preciso de acesso)
2. Atualizar o `.env.example` com melhor documentação
3. Criar o sistema de validação de env vars
4. Organizar os scripts de utilidade

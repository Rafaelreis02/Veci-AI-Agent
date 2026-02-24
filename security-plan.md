# 🔐 PLANO DE SEGURANÇA - VecinoCustom Influencer Platform

## 🎯 Objetivo
Tornar a plataforma 100% segura, usando 1Password para gestão de todos os secrets e tokens.

---

## 📋 FASE 1: Auditoria de Segurança (Hoje)

### 1.1 Verificar Secrets no Histórico Git
- [ ] Auditar todo o histórico git por secrets expostos
- [ ] Verificar ficheiros de teste com dados reais
- [ ] Confirmar `.env.example` não tem valores reais
- [ ] Verificar scripts hardcoded (test-apify.ts, etc.)

### 1.2 Lista de Secrets a Migrar para 1Password

| Secret | Local Atual | Prioridade |
|--------|-------------|------------|
| `DATABASE_URL` | .env / Vercel | 🔴 Alta |
| `NEXTAUTH_SECRET` | .env / Vercel | 🔴 Alta |
| `SHOPIFY_ACCESS_TOKEN` | .env / Vercel | 🔴 Alta |
| `APIFY_API_KEY` | Código/scripts | 🔴 Alta |
| `GOOGLE_GEMINI_API_KEY` | .env / Vercel | 🔴 Alta |
| `GMAIL_CLIENT_SECRET` | .env / Vercel | 🔴 Alta |
| `VERCEL_TOKEN` | Possivelmente local | 🟡 Média |
| `AWS_ACCESS_KEY_ID` | .env (se usado) | 🟡 Média |
| `AWS_SECRET_ACCESS_KEY` | .env (se usado) | 🟡 Média |

---

## 📋 FASE 2: Setup 1Password (Hoje)

### 2.1 Estrutura de Vaults

```
VecinoCustom/
├── 📁 Production
│   ├── DATABASE_URL
│   ├── NEXTAUTH_SECRET
│   ├── SHOPIFY_ACCESS_TOKEN
│   └── ...
├── 📁 Development
│   ├── DATABASE_URL (dev)
│   ├── NEXTAUTH_SECRET (dev)
│   └── ...
├── 📁 APIs & Services
│   ├── Apify API Key
│   ├── Google Gemini API Key
│   ├── Gmail Client Secret
│   └── ...
└── 📁 Infrastructure
    ├── Vercel Token
    ├── GitHub Token (se necessário)
    └── ...
```

### 2.2 Criar Items no 1Password

Para cada secret:
1. Criar item tipo "Password" ou "API Credential"
2. Adicionar tags: `vecinocustom`, `production`/`development`
3. Documentar uso no campo "Notes"

---

## 📋 FASE 3: Limpeza de Código (Amanhã)

### 3.1 Remover Secrets Hardcoded
- [ ] `test-apify.ts` — remover token
- [ ] `scripts/` — verificar todos os scripts
- [ ] `test-*.json` — verificar se têm dados reais
- [ ] Qualquer outro ficheiro com tokens expostos

### 3.2 Implementar Carregamento Seguro

#### Padrão a usar:
```typescript
// Em vez de:
const API_KEY = "sk-abc123..."; // ❌ NUNCA!

// Usar:
const API_KEY = process.env.APIFY_API_KEY; // ✅
if (!API_KEY) {
  throw new Error("APIFY_API_KEY não configurada");
}
```

---

## 📋 FASE 4: Gestão de Secrets em Runtime

### 4.1 Desenvolvimento Local
Usar `op run` para injetar secrets:

```bash
# Criar ficheiro .env.op (não commited!)
op run --env-file=.env.op -- npm run dev
```

### 4.2 Produção (Vercel)
- Secrets permanecem nas Environment Variables do Vercel
- 1Password serve como "source of truth"
- Sincronização manual quando necessário

### 4.3 Scripts de Deploy
```bash
#!/bin/bash
# deploy.sh
set -e

# Carregar secrets do 1Password
export DATABASE_URL=$(op read "op://VecinoCustom/Production/DATABASE_URL")
export NEXTAUTH_SECRET=$(op read "op://VecinoCustom/Production/NEXTAUTH_SECRET")

# Deploy
vercel --prod
```

---

## 📋 FASE 5: Políticas de Segurança

### 5.1 Git Security
- [ ] `.gitignore` atualizado (verificar)
- [ ] Git hooks para pre-commit scan
- [ ] GitHub Secret Scanning ativado
- [ ] Branch protection rules

### 5.2 Environment Variables
- [ ] Documentar todas as variáveis necessárias
- [ ] Separar `.env.example` (template) vs `.env` (real)
- [ ] Nunca commitar `.env` files

### 5.3 Acesso e Permissões
- [ ] Mínimo de pessoas com acesso a Production vault
- [ ] Documentar quem tem acesso
- [ ] Rotacionar passwords periodicamente

---

## 🔧 Implementação Imediata

### Passo 1: Verificar Estado Atual
```bash
# Procurar potenciais secrets no código
grep -r "sk-" --include="*.ts" --include="*.js" --include="*.json" .
grep -r "token" --include="*.ts" --include="*.js" | grep -i "="
grep -r "password" --include="*.ts" --include="*.js" | grep -i "="
```

### Passo 2: Verificar Git History
```bash
# Verificar se algum secret foi commitado acidentalmente
git log --all --full-history --source -- .env
git log --all -p | grep -i "password\|token\|secret\|key" | head -50
```

### Passo 3: Configurar 1Password Vault
1. Criar vault "VecinoCustom" no 1Password
2. Criar sub-vaults se necessário
3. Importar secrets existentes

---

## 🚀 Próximos Passos

1. **Agora:** Verificar se há secrets expostos no código
2. **Depois:** Criar vault no 1Password e organizar secrets
3. **Amanhã:** Limpar código e implementar carregamento seguro
4. **Testar:** Validar que tudo funciona com nova configuração

---

**Notas:**
- 1Password CLI já instalado ✅
- Necessário: conta 1Password com vault configurado
- Ideal: acesso ao Vercel para verificar secrets atuais

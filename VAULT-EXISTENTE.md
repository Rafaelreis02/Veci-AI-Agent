# ✅ USAR VAULT EXISTENTE - VecinoCustom

Já tens vault? **Ótimo!** Não precisas de criar outro.

---

## 🎯 O Que Precisas de Fazer (5 minutos):

### PASSO 1: Verificar Nome do Vault

```bash
# Listar vaults existentes
op vault list
```

Vai mostrar algo tipo:
```
Personal
VecinoCustom        ← Já existe!
Work
```

Ou pode ter outro nome (ex: "Rafael", "Empresa", etc.)

---

### PASSO 2: Adicionar Items ao Vault Existente

**Opção A: Terminal (Rápido)**

```bash
# 1. Verificar qual o nome exato do vault
op vault list

# 2. Adicionar cada secret (substitui "NOME_DO_VAULT" pelo nome real)

# Database
op item create --vault="NOME_DO_VAULT" --title="DATABASE_URL" --category=password password="postgresql://..."

# NextAuth  
op item create --vault="NOME_DO_VAULT" --title="NEXTAUTH_SECRET" --category=password password="..."
op item create --vault="NOME_DO_VAULT" --title="NEXTAUTH_URL" --category=password password="https://vecinocustom-influencer-platform.vercel.app"

# APIs
op item create --vault="NOME_DO_VAULT" --title="APIFY_TOKEN" --category=password password="..."
op item create --vault="NOME_DO_VAULT" --title="ANTHROPIC_API_KEY" --category=password password="..."

# Shopify
op item create --vault="NOME_DO_VAULT" --title="SHOPIFY_CLIENT_SECRET" --category=password password="..."
```

**Opção B: App 1Password (Mais fácil)**

1. Abre a app do 1Password
2. Vai ao vault que já tens
3. Clica no `+` (New Item)
4. Escolhe "Password"
5. Preenche:
   - **Title:** `DATABASE_URL`
   - **Password:** `postgresql://...` (valor real)
6. Repete para cada secret

---

### PASSO 3: Atualizar Ficheiro .env.op

No projeto, cria ficheiro `.env.op` com:

```bash
# Substitui "NOME_DO_VAULT" pelo nome do teu vault
DATABASE_URL=op://NOME_DO_VAULT/DATABASE_URL
NEXTAUTH_SECRET=op://NOME_DO_VAULT/NEXTAUTH_SECRET
NEXTAUTH_URL=op://NOME_DO_VAULT/NEXTAUTH_URL
APIFY_TOKEN=op://NOME_DO_VAULT/APIFY_TOKEN
ANTHROPIC_API_KEY=op://NOME_DO_VAULT/ANTHROPIC_API_KEY
# ... etc
```

---

### PASSO 4: Testar

```bash
# Testar se consegue ler
op read "op://NOME_DO_VAULT/DATABASE_URL"

# Correr app
op run --env-file=.env.op -- npm run dev
```

---

## 📝 Lista de Secrets a Adicionar

Copia do Vercel para o 1Password:

- [ ] `DATABASE_URL`
- [ ] `NEXTAUTH_SECRET`
- [ ] `NEXTAUTH_URL`
- [ ] `APIFY_TOKEN`
- [ ] `ANTHROPIC_API_KEY` (ou `GOOGLE_GEMINI_API_KEY`)
- [ ] `SHOPIFY_CLIENT_SECRET` (se usar Shopify)
- [ ] `GMAIL_CLIENT_SECRET` (se usar Gmail)
- [ ] `CRON_SECRET`

---

## 💡 Dica

Podes organizar com **Sections** no 1Password:
- Section: "Production"
- Section: "APIs"
- Section: "Shopify"

Ou deixar tudo na root do vault — funciona igual!

---

**Qual é o nome do vosso vault?** Assim faço-te o `.env.op` já com o nome correto.

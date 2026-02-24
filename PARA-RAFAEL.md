# ============================================
# INSTRUÇÕES PARA O RAFAEL
# ============================================

Como o 1Password requer autenticação PESSOAL (a tua password),
não posso fazer tudo automaticamente. Mas preparei tudo para ser SUPER FÁCIL!

## 🚀 OPÇÃO 1: Script Guiado (Recomendada - 2 minutos)

```bash
# 1. Abre terminal no teu computador
# 2. Vai à pasta do projeto
cd vecinocustom-influencer-platform

# 3. Corre o script guiado
./setup-guided.sh
```

O script vai:
- ✅ Verificar se tens 1Password CLI
- ✅ Guiar-te na autenticação
- ✅ Criar o vault "VecinoCustom"
- ✅ Pedir-te os secrets (DATABASE_URL, etc.)
- ✅ Guardar tudo no 1Password

## 🚀 OPÇÃO 2: Eu faço os ficheiros, tu configuras (1 minuto)

Se quiseres que eu prepare os ficheiros e tu só copias os valores:

### PASSO 1: Copiar ficheiros para o teu projeto

Copia estes ficheiros do workspace para o teu repo:
- `env.example` → `.env.example` (atualizado)
- `env.ts` → `src/lib/env.ts` (validação)
- `env.op` → `.env.op` (config 1Password)
- `deploy.sh` → `scripts/deploy.sh`
- `setup-guided.sh` → `scripts/setup-guided.sh`

### PASSO 2: Configurar 1Password (manual)

```bash
# 1. Autenticar no 1Password
op signin

# 2. Criar vault
op vault create VecinoCustom

# 3. Adicionar cada secret
op item create --vault=VecinoCustom --title="DATABASE_URL" --category=password password="postgresql://..."
op item create --vault=VecinoCustom --title="NEXTAUTH_SECRET" --category=password password="..."
# ... etc
```

### PASSO 3: Usar

```bash
# Correr app
op run --env-file=.env.op -- npm run dev

# Deploy
./scripts/deploy.sh production
```

## 📋 O que precisas de ter:

1. **1Password instalado** (app ou browser extension)
2. **1Password CLI instalado**:
   - macOS: `brew install 1password-cli`
   - Windows: `winget install AgileBits.1Password.CLI`
3. **Secrets do projeto** (copiar do Vercel ou do teu .env atual):
   - DATABASE_URL
   - NEXTAUTH_SECRET
   - NEXTAUTH_URL
   - APIFY_TOKEN
   - SHOPIFY_CLIENT_SECRET
   - etc.

## 🤔 Qual escolher?

- **Se quiseres rápido**: Opção 1 (script guiado)
- **Se quiseres controlo**: Opção 2 (manual)

## 💬 Queres que eu faça o quê?

Posso:
1. **Criar um PR no GitHub** com os ficheiros de configuração
2. **Fazer um vídeo/guia** passo a passo
3. **Aguardar** enquanto corres o script e ajudar se houver erros
4. **Criar versão simplificada** só com o essencial

Diz-me o que preferes! 🚀

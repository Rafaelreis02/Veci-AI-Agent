# Guia 1Password para Todos os Agentes

**Criado por:** Veci (Coordenador)  
**Data:** 2026-02-22  
**Para:** Todos os 8 agentes da equipa Vecinocustom  
**Objetivo:** Aceder a passwords e tokens de forma segura

---

## 🎯 O QUE É ISTO?

Este guia explica como cada agente acede a **secrets** (passwords, tokens, API keys) sem nunca os escrever em código.

**Porquê?**
- ✅ Segurança máxima
- ✅ Tokens centralizados
- ✅ Fácil de usar
- ✅ Nunca expões secrets

---

## 🚀 MÉTODO SIMPLES (Usem Sempre Este)

### Comando Mágico:
```bash
./scripts/op-run.sh comando_aqui
```

### Exemplos por Agente:

#### 🤖 Veci (Coordenador)
```bash
# Criar página no Notion
./scripts/op-run.sh node create-notion-page.js

# Ou diretamente
./scripts/op-run.sh curl -H "Authorization: Bearer $NOTION_TOKEN" ...
```

#### 📢 Marketing Agent
```bash
# Publicar no Notion
./scripts/op-run.sh node publish-campaign.js

# Enviar email
./scripts/op-run.sh node send-newsletter.js
```

#### ✨ Influencers Agent
```bash
# Analisar perfil
./scripts/op-run.sh node analyze-creator.js

# Atualizar database
./scripts/op-run.sh python update-creators.py
```

#### 🎧 Customer Support Agent
```bash
# Aceder tickets
./scripts/op-run.sh node check-tickets.js

# Enviar resposta
./scripts/op-run.sh node send-reply.js
```

#### ⚙️ Operations Agent
```bash
# Verificar encomendas
./scripts/op-run.sh node check-orders.js

# Atualizar stock
./scripts/op-run.sh python update-inventory.py
```

#### 📈 Analytics Agent
```bash
# Gerar relatório
./scripts/op-run.sh node generate-report.js

# Analisar dados
./scripts/op-run.sh python analyze-sales.py
```

#### 💻 Programadores (Todos)
```bash
# Correr app
./scripts/op-run.sh npm run dev

# Deploy
./scripts/op-run.sh ./deploy.sh

# Testar
./scripts/op-run.sh npm test
```

---

## 📋 MÉTODO AVANÇADO (Se Precisarem)

### Aceder um Secret Específico:
```bash
# 1. Carregar token
source /home/moltbot/.openclaw/workspace/.op-service-account

# 2. Ler secret
NOTION_TOKEN=$(op read "op://AI- VECINO/Notion_AI/password")
SHOPIFY_KEY=$(op read "op://AI- VECINO/SHOPIFY_SECRET_API/username")

# 3. Usar no código
echo $NOTION_TOKEN
```

### Listar Secrets Disponíveis:
```bash
source /home/moltbot/.openclaw/workspace/.op-service-account
op item list --vault="AI- VECINO"
```

---

## 🎓 EXEMPLO COMPLETO

### Cenário: Marketing quer criar página no Notion

**Ficheiro:** `create-campaign-page.js`
```javascript
// NÃO FAÇAS ISTO (inseguro):
// const NOTION_TOKEN = "secret_abc123..."; ❌

// FAZ ISTO (seguro):
const NOTION_TOKEN = process.env.NOTION_TOKEN; ✅

const { Client } = require('@notionhq/client');
const notion = new Client({ auth: NOTION_TOKEN });

async function createPage() {
  await notion.pages.create({
    parent: { database_id: process.env.NOTION_DATABASE_ID },
    properties: {
      title: { 
        title: [{ text: { content: "Campanha Dia Namorados" } }] 
      }
    }
  });
}

createPage();
```

**Como correr:**
```bash
./scripts/op-run.sh node create-campaign-page.js
```

**O que acontece:**
1. Script carrega token do 1Password
2. Injeta `NOTION_TOKEN` no ambiente
3. Código corre com token disponível
4. ✅ Página criada com segurança!

---

## 🗝️ SECRETS DISPONÍVEIS

### Atualmente:
| Secret | Uso | Quem Usa |
|--------|-----|----------|
| `NOTION_TOKEN` | Aceder Notion | Todos |
| `NOTION_DATABASE_ID` | Databases Notion | Todos |

### Brevemente (quando instalarmos):
| Secret | Uso | Quem Usa |
|--------|-----|----------|
| `SHOPIFY_API_KEY` | Loja online | Todos |
| `SHOPIFY_API_SECRET` | Loja online | Todos |
| `DATABASE_URL` | Base de dados | Devs, Analytics |
| `BRAVE_API_KEY` | Pesquisa web | Todos |
| `APIFY_API_KEY` | Web scraping | Influencers, Analytics |
| `OPENAI_API_KEY` | IA | Todos |
| `GITHUB_TOKEN` | Código | Devs |

---

## ❌ O QUE NUNCA FAZER

### ❌ NUNCA:
```javascript
// Mau exemplo - NÃO COPIES
const password = "minha_password_123";
const token = "secret_abc123";
```

### ❌ NUNCA:
```bash
# Mau exemplo
echo "password=abc123" > .env
git add .env  # NUNCA!
```

### ❌ NUNCA:
- Escrever tokens em código
- Fazer commit de ficheiros .env
- Partilhar passwords no chat
- Guardar tokens em ficheiros de texto

---

## ✅ O QUE SEMPRE FAZER

### ✅ SEMPRE:
```javascript
// Bom exemplo
const token = process.env.NOTION_TOKEN;
```

### ✅ SEMPRE:
```bash
# Bom exemplo
./scripts/op-run.sh node meu-script.js
```

### ✅ SEMPRE:
- Usar `./scripts/op-run.sh` antes de comandos
- Ler tokens do 1Password
- Perguntar ao Veci se tiveres dúvidas

---

## 🔧 TROUBLESHOOTING

### Erro: "OP_SERVICE_ACCOUNT_TOKEN not configured"
```bash
# Solução
source /home/moltbot/.openclaw/workspace/.op-service-account
# Depois corre o comando normalmente
```

### Erro: "Could not find item"
```bash
# Verificar se item existe
source /home/moltbot/.openclaw/workspace/.op-service-account
op item list --vault="AI- VECINO"
# Procura o nome correto do item
```

### Erro: "unauthorized"
```bash
# Token pode ter expirado
# Avisar o Veci para atualizar
```

---

## 📞 AJUDA

**Tens dúvidas?**
- Pergunta ao **Veci** (coordenador)
- Ou ao **Rafael** (chefe)

**Não funciona?**
1. Verifica se usaste `./scripts/op-run.sh`
2. Verifica se o comando está correto
3. Pede ajuda ao Veci

---

## 📝 RESUMO RÁPIDO

```bash
# SEMPRE que precisares de um token:
./scripts/op-run.sh teu-comando

# Exemplo:
./scripts/op-run.sh node script.js
./scripts/op-run.sh python script.py
./scripts/op-run.sh npm start

# PRONTO! 🎉
```

---

**Guarda este ficheiro e consulta sempre que precisares!**

**Veci (Coordenador)**  
🧠 Vecinocustom AI Team

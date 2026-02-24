# 1Password para Agentes - Guia Completo

**Data:** 2026-02-22  
**Objetivo:** Todos os agentes acederem a secrets de forma segura  
**Método:** Service Account (autenticação automática)

---

## 🎯 O QUE VAMOS CONFIGURAR

**Problema:** Cada skill precisa de tokens/passwords (Notion, Shopify, APIs...)
**Solução:** 1Password Service Account que todos os agentes usam
**Resultado:** 
- ✅ Secrets centralizados e seguros
- ✅ Nenhum token exposto em código
- ✅ Todos os agentes acedem automaticamente
- ✅ Rotação de secrets facilitada

---

## 🔧 PASSO A PASSO

### PASSO 1: Rafael cria Service Account (5 min)

**No teu computador:**

1. Abre browser → https://my.1password.com/serviceaccounts
2. Clica **"Create Service Account"**
3. Configura:
   - **Name:** `Veci AI Agents`
   - **Vault:** Seleciona `VecinoCustom`
   - **Permissions:** ✅ `Read Items` (só leitura, mais seguro)
4. Clica **"Create"**
5. **Copia o token** que aparece (começa com `ops_...`)
6. Guarda num Secure Note no 1Password (backup)

---

### PASSO 2: Configurar no servidor (eu faço)

**Eu vou:**

1. Editar `.op-service-account` com o token
2. Testar autenticação
3. Criar ficheiro `.op-env` com mapeamentos
4. Configurar wrapper scripts

**Para testar:**
```bash
./scripts/test-1password.sh
```

---

### PASSO 3: Guardar secrets no 1Password

**Estrutura do Vault `VecinoCustom`:**

```
VecinoCustom Vault
├── 🔐 Notion
│   └── token: secret_abc123...
│
├── 🔐 Shopify (depois)
│   ├── api_key: xxx
│   ├── api_secret: yyy
│   └── store_url: zzz
│
├── 🔐 APIs (depois)
│   ├── openai: sk-...
│   ├── anthropic: sk-...
│   └── apify: apl...
│
└── 🔐 Outros (conforme necessário)
    └── ...
```

---

## 🎮 COMO USAR (Exemplos)

### Exemplo 1: Notion Token

**No 1Password:**
- Vault: `VecinoCustom`
- Item: `Notion`
- Field: `token`
- Valor: `secret_abc123...`

**No código da skill:**
```javascript
// NOT op://VecinoCustom/Notion/token
const NOTION_TOKEN = process.env.NOTION_TOKEN;
```

**No ficheiro `.op-env`:**
```bash
NOTION_TOKEN=op://VecinoCustom/Notion/token
```

**Para correr:**
```bash
./scripts/op-run.sh node notion-skill.js
```

**O que acontece:**
1. Script carrega Service Account token
2. 1Password CLI autentica automaticamente
3. Lê `op://VecinoCustom/Notion/token`
4. Injeta `NOTION_TOKEN=secret_abc123...` no ambiente
5. Comando corre com token disponível

---

### Exemplo 2: Múltiplos secrets

**Ficheiro `.op-env`:**
```bash
# Notion
NOTION_TOKEN=op://VecinoCustom/Notion/token
NOTION_DATABASE_ID=op://VecinoCustom/Notion/database_id

# Shopify
SHOPIFY_API_KEY=op://VecinoCustom/Shopify/api_key
SHOPIFY_API_SECRET=op://VecinoCustom/Shopify/api_secret

# OpenAI
OPENAI_API_KEY=op://VecinoCustom/APIs/openai
```

**Usar:**
```bash
./scripts/op-run.sh npm start
# Todas as variáveis ficam disponíveis
```

---

### Exemplo 3: Skill específica

**Skill: notion-integration**
```javascript
// SKILL.md
name: notion-integration
config:
  token: ${NOTION_TOKEN}  # Lê do ambiente
  
// Código
const { Client } = require('@notionhq/client');
const notion = new Client({ auth: process.env.NOTION_TOKEN });
```

**Ativar:**
```bash
# Via wrapper
./scripts/op-run.sh openclaw skill enable notion-integration

# Ou no código da skill
const token = process.env.NOTION_TOKEN;
```

---

## 👥 COMO CADA AGENTE USA

### Veci (Coordenador)
```bash
# Configurar ambiente
source .op-service-account

# Testar acesso
op vault list
op item list --vault="VecinoCustom"

# Ler secret específico
NOTION_TOKEN=$(op read "op://VecinoCustom/Notion/token")
```

### Marketing Agent
```bash
# Usar via wrapper (recomendado)
./scripts/op-run.sh node marketing-campaign.js

# Ou direto se já tiver source
op run --env-file=.op-env -- node script.js
```

### Todos os Agentes
**Padrão:** Cada agente que precisar de secrets:
1. Chama `./scripts/op-run.sh` antes do comando
2. Ou lê diretamente: `op read "op://..."`

---

## 📁 FICHEIROS CRIADOS

| Ficheiro | Propósito | Protegido |
|----------|-----------|-----------|
| `.op-service-account` | Token do Service Account | ✅ Sim (gitignore) |
| `.op-env` | Mapeamento secrets→env | ✅ Sim (gitignore) |
| `scripts/op-run.sh` | Wrapper para correr com secrets | ✅ Público |
| `scripts/test-1password.sh` | Testar configuração | ✅ Público |
| `scripts/setup-1password-service-account.sh` | Setup inicial | ✅ Público |

---

## 🔒 SEGURANÇA

### Porquê Service Account?
- ✅ Não precisa de login interativo
- ✅ Token pode ser revogado a qualquer momento
- ✅ Permissões granulares (só leitura)
- ✅ Auditoria de acessos

### Boas Práticas:
1. **Token nunca em código** (só no .op-service-account)
2. **Permissões mínimas** (read only para agents)
3. **Rotação regular** (trocar token a cada X meses)
4. **Auditoria** (logs de quem acedeu o quê)

### O que NÃO fazer:
- ❌ Nunca fazer commit do token
- ❌ Nunca partilhar token em chat
- ❌ Nunca dar permissões de escrita desnecessárias

---

## 🧪 TESTAR

### Teste 1: Configuração
```bash
./scripts/test-1password.sh
```
**Esperado:** Lista de vaults e items

### Teste 2: Ler secret
```bash
source .op-service-account
op read "op://VecinoCustom/Notion/token"
```
**Esperado:** Mostra o valor do token

### Teste 3: Wrapper
```bash
./scripts/op-run.sh echo "NOTION_TOKEN=$NOTION_TOKEN"
```
**Esperado:** Mostra token mascarado ou valor

---

## 📋 CHECKLIST

- [ ] Rafael: Criar Service Account no 1Password
- [ ] Rafael: Copiar token (ops_...)
- [ ] Veci: Configurar .op-service-account
- [ ] Veci: Testar autenticação
- [ ] Rafael: Criar items no vault (Notion, etc.)
- [ ] Veci: Configurar .op-env
- [ ] Veci: Testar leitura de secrets
- [ ] Documentar uso para cada agente

---

## 🚀 PRÓXIMOS PASSOS

1. **Agora:** Rafael cria Service Account e envia token
2. **Depois:** Eu configuro tudo no servidor
3. **Seguinte:** Testamos com Notion
4. **Depois:** Configuramos Shopify e outras skills

---

## 💡 EXEMPLO COMPLETO

### Cenário: Ativar skill Notion

**1. Rafael guarda token no 1Password:**
```
Vault: VecinoCustom
Item: Notion
  - token: secret_abc123...
  - database_id: 123456...
```

**2. Veci configura .op-env:**
```bash
NOTION_TOKEN=op://VecinoCustom/Notion/token
NOTION_DATABASE_ID=op://VecinoCustom/Notion/database_id
```

**3. Skill notion-integration usa:**
```javascript
const notion = new Client({ 
  auth: process.env.NOTION_TOKEN 
});
```

**4. Ativar skill:**
```bash
./scripts/op-run.sh openclaw skill enable notion-integration
```

**5. Funciona!** 🎉

---

**Documento criado por Veci para configuração segura de secrets.**

🔐 **Lembrete:** "Segurança não é opção, é fundação."

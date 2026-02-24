# Guia Completo: Configurar Notion para Veci (100% Detalhado)

**Data:** 2026-02-22  
**Objetivo:** Permitir que Veci aceda e edite páginas no Notion  
**Tempo estimado:** 10-15 minutos

---

## 🎯 O QUE VAMOS FAZER

Precisamos de:
1. Criar uma integração (app) no Notion
2. Dar permissões dessa app para o workspace
3. Copiar o token de acesso
4. Guardar no 1Password (já está feito)
5. Testar a conexão

---

## 📋 PASSO 1: CRIAR INTEGRAÇÃO NO NOTION

### 1.1 Abrir página de integrações
```
1. Abre o browser (Chrome, Safari, etc.)
2. Vai a: https://www.notion.so/my-integrations
3. Faz login com a tua conta (se ainda não estiveres logged in)
```

**O que vês:** Uma página com o título "My integrations" e possivelmente vazia (se nunca criaste nenhuma)

### 1.2 Criar nova integração
```
1. Clica no botão azul: "+ New integration"
2. Vais ver um formulário para preencher
```

### 1.3 Preencher dados da integração

**Campo: "Integration name"**
```
Escreve: Veci AI Agent
```

**Campo: "Associated workspace"**
```
Clica no dropdown
Seleciona: "Vecinocustom AI Team" (ou o nome do teu workspace)
```

**Campo: "Type"**
```
Seleciona: "Internal" (NÃO seleciones "Public")
```

**Campo: "Logo" (opcional)**
```
Podes carregar uma imagem ou deixar vazio
```

**Campo: "Terms of Use URL"**
```
Escreve: https://vecinocustom.com/terms
(ou se não tiveres: https://www.notion.so)
```

**Campo: "Privacy Policy URL"**
```
Escreve: https://vecinocustom.com/privacy
(ou se não tiveres: https://www.notion.so)
```

**Campo: "Support email"**
```
Escreve: rafael@vecinocustom.com
```

### 1.4 Submeter
```
Clica no botão azul: "Submit"
```

**O que acontece:** A página recarrega e vês a integração "Veci AI Agent" na lista

---

## 📋 PASSO 2: COPIAR O TOKEN (Internal Integration Token)

### 2.1 Ver detalhes da integração
```
1. Clica no nome "Veci AI Agent" na lista
2. Abre uma página de detalhes
```

### 2.2 Encontrar o token
```
Na página de detalhes, procura a secção:
"Internal Integration Token"

Vês uma caixa com texto escondido (tipo: secret_••••••••)
```

### 2.3 Revelar e copiar o token
```
1. Clica no botão "Show" (ou ícone de olho) ao lado do token
2. O token aparece completo (começa com "secret_")
3. Clica no botão "Copy" para copiar
4. GUARDA ESTE TOKEN NUM SITIO SEGURO (1Password)
```

(token-removed)

---

## 📋 PASSO 3: ADICIONAR INTEGRAÇÃO AO WORKSPACE

**IMPORTANTE:** O token sozinho NÃO BASTA! Precisas de dar permissão da integração para aceder ao workspace.

### 3.1 Ir às definições do workspace
```
1. No Notion (notion.so), clica no ícone do workspace
   (canto superior esquerdo, onde está o nome "Vecinocustom AI Team")
2. No menu que abre, clica em "Settings"
3. Ou diretamente: https://www.notion.so/settings
```

### 3.2 Ir a Integrations
```
No menu da esquerda, clica em: "Integrations"
```

**O que vês:** Lista de integrações disponíveis para o workspace

### 3.3 Ativar a integração
```
Procura "Veci AI Agent" na lista

Se estiver "Disabled":
  1. Clica em "Veci AI Agent"
  2. Clica no toggle para mudar para "Enabled"
  3. Clica "Allow access"

Se NÃO estiver na lista:
  1. Clica em "+ Add integration"
  2. Procura "Veci AI Agent"
  3. Seleciona
  4. Clica "Add to workspace"
  5. Clica "Allow"
```

### 3.4 Verificar permissões
```
Clica em "Veci AI Agent" nas integrações ativas

Verifica se tem estas permissões ativas:
☑️ Read content (Ler conteúdo)
☑️ Update content (Atualizar conteúdo)  
☑️ Insert content (Inserir conteúdo)
```

---

## 📋 PASSO 4: DAR ACESSO A PÁGINAS ESPECÍFICAS (CRUCIAL)

**O Notion funciona assim:** Mesmo com a integração ativa, ela só pode aceder às páginas que TU especificamente partilhares com ela.

### 4.1 Criar página para o Veci (opcional, mas recomendado)
```
1. No Notion, clica em "+ New page" (canto inferior esquerdo)
2. Título: "Veci AI - Workspace"
3. Clica em "Share" (canto superior direito)
4. Clica em "Add people, emails, groups or integrations"
5. Procura e seleciona: "Veci AI Agent"
6. Clica em "Invite"
7. Dá permissão "Can edit" (ou "Full access")
```

### 4.2 Dar acesso a páginas existentes (se quiseres)
```
Para cada página onde queres que o Veci trabalhe:

1. Abre a página
2. Clica em "Share" (canto superior direito)
3. Clica em "Add people..."
4. Seleciona "Veci AI Agent"
5. Escolhe permissão: "Can edit"
6. Clica "Invite"
```

**Permissões disponíveis:**
- "Can view" → Só lê
- "Can comment" → Lê e comenta
- "Can edit" → Lê, edita, cria (RECOMENDADO)
- "Full access" → Controlo total

---

## 📋 PASSO 5: GUARDAR TOKEN NO 1PASSWORD (JÁ FEITO)

**Se ainda não guardaste:**
```
1. Abre 1Password
2. Clica "+ New Item"
3. Seleciona "Secure Note" ou "Password"
4. Título: "Notion - Veci AI Integration Token"
5. Cola o token no campo de texto/password
6. Guarda
```

---

## 📋 PASSO 6: TESTAR (EU FAÇO)

Depois de fazeres tudo isto, eu testo:
```bash
# Testar se consigo aceder
curl -X GET "https://api.notion.com/v1/users/me" \
  -H "Authorization: Bearer TOKEN" \
  -H "Notion-Version: 2022-06-28"
```

Se responder com dados do bot (em vez de erro 401), está tudo OK!

---

## 🔧 RESUMO VISUAL

```
┌─────────────────────────────────────────────────────────┐
│  PASSO 1: Criar Integração                              │
│  https://www.notion.so/my-integrations                  │
│  → + New integration                                    │
│  → Nome: "Veci AI Agent"                                │
│  → Workspace: "Vecinocustom AI Team"                    │
│  → Type: "Internal"                                     │
│  → Submit                                               │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│  PASSO 2: Copiar Token                                  │
│  → Clica em "Veci AI Agent"                             │
│  → "Show" no Internal Integration Token                 │
│  → "Copy"                                               │
│  → Guarda no 1Password                                  │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│  PASSO 3: Adicionar ao Workspace                        │
│  https://www.notion.so/settings                         │
│  → Integrations                                         │
│  → Encontra "Veci AI Agent"                             │
│  → Toggle para "Enabled"                                │
│  → "Allow access"                                       │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│  PASSO 4: Partilhar Páginas                             │
│  Na página "Veci AI - Workspace":                       │
│  → Share                                                │
│  → Add "Veci AI Agent"                                  │
│  → "Can edit"                                           │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│  ✅ PRONTO! Veci pode agora criar/editar páginas        │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ ERROS COMUNS E SOLUÇÕES

### Erro: "API token is invalid"
**Causa:** Token copiado incorretamente ou integração não ativa
**Solução:**
1. Volta a https://www.notion.so/my-integrations
2. Clica em "Veci AI Agent"
3. Clica "Show" no token
4. Copia de novo (certifica-te que copias TUDO desde "secret_" até ao fim)
5. Guarda no 1Password

### Erro: "Unauthorized"
**Causa:** Integração não foi adicionada ao workspace
**Solução:**
1. Vai a https://www.notion.so/settings
2. Clica "Integrations"
3. Procura "Veci AI Agent"
4. Ativa o toggle

### Erro: "Could not find page"
**Causa:** Veci não tem acesso à página específica
**Solução:**
1. Abre a página no Notion
2. Clica "Share"
3. Adiciona "Veci AI Agent" com permissão "Can edit"

---

## ✅ CHECKLIST FINAL

Antes de me dizeres que está pronto, verifica:

- [ ] Criei integração "Veci AI Agent" em my-integrations
- [ ] Copiei o token (secret_...)
- [ ] Guardei token no 1Password
- [ ] Adicionei integração ao workspace em Settings → Integrations
- [ ] Ativei as permissões (Read, Update, Insert)
- [ ] Criei página "Veci AI - Workspace" no Notion
- [ ] Partilhei essa página com "Veci AI Agent" (Can edit)

---

## 🚀 QUANDO TERMINARES

Quando completares todos os passos, diz-me:
> "Pronto, Veci! Podes testar."

Eu vou:
1. Testar a conexão
2. Criar página de teste
3. Confirmar que está tudo OK

---

**Se tiveres DÚVIDAS em qualquer passo, pergunta-me!** 🧠

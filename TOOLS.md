# TOOLS.md - Minhas Ferramentas e Notas

## Skills Ativas (Capacidade/Cognição)

### Brave Search
- **Local:** `/home/moltbot/.openclaw/workspace/skills/brave-search/SKILL.md`
- **Uso:** Pesquisas na web, tendências, notícias
- **Categoria:** Research & Information Retrieval

### Web Fetch
- **Disponível:** Sim
- **Uso:** Extrair conteúdo de URLs em markdown/texto
- **Categoria:** Data Extraction

### Browser Control
- **Disponível:** Sim
- **Uso:** Automação web, screenshots, preencher formulários
- **Categoria:** Web Automation

### TTS (Text-to-Speech)
- **Disponível:** Sim
- **Uso:** Converter texto em voz
- **Categoria:** Voice Generation

### File Management
- **Disponível:** Sim (read/write/edit/exec)
- **Uso:** Gestão de ficheiros, código, documentos
- **Categoria:** File Operations

### Memory System
- **Disponível:** Sim (memory_search, memory_get)
- **Uso:** Memória de curto e longo prazo
- **Categoria:** Cognitive/Memory

### 1Password
- **Disponível:** Sim
- **Uso:** Gestão segura de secrets/passwords
- **Categoria:** Security

### Weather
- **Disponível:** Sim
- **Uso:** Temperatura, forecast
- **Categoria:** Information Retrieval

### TMux
- **Disponível:** Sim
- **Uso:** Controlar sessões de terminal
- **Categoria:** System Operations

### Healthcheck
- **Disponível:** Sim
- **Uso:** Verificações de segurança do servidor
- **Categoria:** Security/System

---

## Notas da Empresa

### Tech Stack
- Vercel (hosting)
- GitHub (código)
- Supabase/Neon.tech (base de dados)
- Shopify (e-commerce platform)

### Website
- www.vecinocustom.com

### Estatísticas
- ~1500 encomendas/mês
- Ticket médio: 60€

---

## Skills Prioritárias (Deep Search 2026-02-22)

### Core Skills (Implementar Já) - PRIORIDADES DO RAFAEL

| # | Skill | Impacto | Esforço | Agente | Prioridade |
|---|-------|---------|---------|--------|------------|
| 1 | **Shopify** | ⭐⭐⭐⭐⭐ | Médio | Todos | 🔴 CRÍTICA |
| 2 | **GA4 Analytics** | ⭐⭐⭐⭐⭐ | Médio | Análises, Marketing | 🔴 CRÍTICA |
| 3 | **Instagram** | ⭐⭐⭐⭐⭐ | Baixo | Influencers, Marketing | 🔴 CRÍTICA |
| 4 | **AgentMail** | ⭐⭐⭐⭐ | Baixo | Marketing, Support | 🟡 Alta |
| 5 | **Playwright Scraper** | ⭐⭐⭐⭐ | Alto | Análises, Influencers | 🟡 Alta |
| 6 | **Automation Workflows** | ⭐⭐⭐⭐ | Médio | Todos | 🟡 Alta |
| 7 | **Marketing Skills** | ⭐⭐⭐ | Baixo | Marketing | 🟢 Média |
| - | Klaviyo API | ⭐⭐⭐⭐⭐ | Médio | Marketing + Email Dev | 🔴 Alta |
| - | WhatsApp Business API | ⭐⭐⭐⭐⭐ | Médio | Support | 🔴 Alta |

### Ferramentas de Automação
- **n8n** (recomendado) - Self-hosted, open-source, complexo mas poderoso
- **Make** - Balance de flexibilidade/usabilidade
- **Zapier** - Simples mas caro para volume

### Segurança Essencial
- ✅ 1Password CLI (já temos)
- 🔄 Audit logging (skill a criar)
- 🔄 Data masking (skill a criar)
- 🔄 Rate limiting
- 🔄 GDPR compliance tools

---

## Skills de Capacidade Recomendadas (Deep Search 2026-02-22)

### 🔴 Prioridade Alta (Implementar Já)

| Skill | Descrição | Agentes | Tipo |
|-------|-----------|---------|------|
| **Self-Reflection** | Aprender com erros e melhorar | Todos (especialmente Veci) | Self-Improvement |
| **Data Analysis (Pandas AI)** | Análise conversacional de CSV/Excel | Análises, Marketing, Ops | Cognitiva |
| **Code Execution Sandbox** | Executar código Python/Node.js isolado | Programadores, Análises | Execução |
| **Product Recommendation** | Recomendações inteligentes | Marketing, Support | E-Commerce |
| **Knowledge Base RAG** | Sistema de documentação e FAQ | Support, Todos | Cognitiva |
| **Audit Logger** | Registo de todas as ações | Todos (compliance) | Segurança |

### 🟡 Prioridade Média (1-2 meses)

| Skill | Descrição | Agentes | Tipo |
|-------|-----------|---------|------|
| **Image Generation** | Criar imagens (DALL-E/Stable Diffusion) | Marketing, Influencers | Criação |
| **Voice/TTS (ElevenLabs)** | Voz ultra-realista | Marketing, Support | Criação |
| **Task Planning** | Gestão de tarefas e deadlines | Todos | Produtividade |
| **Multi-Agent Orchestrator** | Coordenação entre agentes | Veci (coordenador) | Coordenação |
| **Content Generation** | Geração avançada de copy/texto | Marketing | Criação |

### 🟢 Prioridade Baixa (3-6 meses)

| Skill | Descrição | Agentes | Tipo |
|-------|-----------|---------|------|
| **Reasoning Engine** | Chain-of-Thought, Tree-of-Thought | Todos | Cognitiva |
| **Decision Support** | Apoio à tomada de decisões | Rafael | Cognitiva |
| **Advanced Memory** | Memória semântica + episódica | Todos | Cognitiva |
| **Data Masking** | Mascaramento de PII/dados sensíveis | Support, Ops | Segurança |

---

### Resumo por Categoria

**🧠 Cognitivas:** Memory, Reasoning, Context Management, Knowledge Base  
**🔄 Self-Improvement:** Self-Reflection, Meta-Learning, Continuous Improvement  
**🛒 E-Commerce:** Product Recommendation, Behavior Prediction, Dynamic Pricing, Inventory Intelligence  
**⚙️ Execução:** Code Sandbox, Data Analysis, File Management  
**🎨 Criação:** Image Gen, Voice/TTS, Content Generation  
**🎛️ Coordenação:** Multi-Agent Orchestrator, Task Decomposition  
**🔒 Segurança:** Audit Logger, Data Masking, Permission Manager  
**📋 Produtividade:** Task Planning, Decision Support

---

## 🔒 SEGURANÇA DE SKILLS (CRÍTICO)

### ⚠️ O Problema é Real
- **~12% das skills no ClawHub são maliciosas** (386/2857 auditadas)
- **Campanha ClawHavoc:** 335+ skills maliciosas distribuídas
- **Snyk:** 36% têm prompt injection, 1467 payloads maliciosos

### 🛡️ Verificação Antes de Instalar

**Checklist Obrigatório:**
1. ✅ Verificar fonte (autor confiável, conta > 1 mês, não typosquat)
2. ✅ Ler SKILL.md completo (não correr scripts externos desconhecidos)
3. ✅ Scan VirusTotal (hash SHA-256 verificado)
4. ✅ Testar em sandbox (Docker/VM isolada)
5. ✅ Verificar permissões (mínimo necessário)

**Red Flags (Nunca Instalar):**
- 🚩 Scripts de "pré-instalação" (`curl | bash`)
- 🚩 Download de binários externos
- 🚩 Acesso root/sudo desnecessário
- 🚩 Prompt injection óbvio ("Ignore previous instructions...")
- 🚩 URLs suspeitas (IP diretos, domínios estranhos)

### Ferramentas de Segurança
- **skill-scanner** (Cisco) - Análise estática + comportamental
- **VirusTotal** (integrado no ClawHub)
- **UseClawPro** - Verificação pré-instalação
- **SecureClaw** - Plugin de segurança OWASP

### Documento Completo
📄 Ver `SKILL_SECURITY_GUIDE.md` para checklist detalhado

---

## Para E-commerce (a pesquisar)

- ✅ Ferramentas de análise de concorrentes
- ✅ Plugins de automação (n8n/Make)
- ✅ Integrações com plataformas de pagamento (Stripe)
- ✅ SEO e marketing tools (Klaviyo, Meta Ads)
- 🔄 Analytics dashboard (Looker Studio/Metabase)
- 🔄 Inventory management AI

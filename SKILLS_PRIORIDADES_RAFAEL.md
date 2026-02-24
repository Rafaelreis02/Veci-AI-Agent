# Skills Prioritárias - Lista do Rafael

**Data:** 2026-02-22  
**Definido por:** Rafael Reis  
**Status:** Aprovado para implementação

---

## 📋 LISTA OFICIAL DE SKILLS

### 🔴 PRIORIDADE CRÍTICA (Instalar Primeiro)

---

#### 1. Shopify ⭐⭐⭐⭐⭐
**Esforço:** Médio | **Agentes:** Todos

**O que faz:**
- Integração completa com a plataforma Shopify
- Acesso a produtos, encomendas, clientes em tempo real
- Gestão de stock e inventário
- Processamento de encomendas
- Dados de vendas e métricas

**Porquê é crítico:**
- Vecinocustom vende 100% via Shopify
- ~1500 encomendas/mês para processar
- Base de dados central do negócio
- Todos os agentes precisam destes dados

**Casos de uso:**
- Agente Marketing: "Quais os produtos mais vendidos esta semana?"
- Agente Support: "Qual o estado da encomenda #1234?"
- Agente Análises: "Ticket médio e taxa de conversão"
- Agente Operações: "Stock baixo - alertar fornecedor"

**Implementação:**
```yaml
skill: shopify-api
permissions:
  - read: products, orders, customers
  - write: orders (update status), inventory
  - webhook: order.created, order.updated
security:
  - API key em 1Password
  - Rate limiting: 2 requests/segundo
  - Audit logging ativado
```

---

#### 2. GA4 Analytics ⭐⭐⭐⭐⭐
**Esforço:** Médio | **Agentes:** Análises, Marketing

**O que faz:**
- Integração com Google Analytics 4
- Dados de tráfego, comportamento, conversões
- Relatórios automáticos de performance
- Tracking de campanhas
- Análise de funil de vendas

**Porquê é crítico:**
- Medir ROI de campanhas de marketing
- Entender comportamento dos clientes
- Otimizar taxa de conversão
- Dados para decisões estratégicas

**Casos de uso:**
- "Quantos visitantes tivemos ontem?"
- "Qual a taxa de conversão da campanha X?"
- "De onde vêm os meus clientes?"
- "Alerta: tráfego abaixo da média"

**Métricas chave:**
- Sessions, users, pageviews
- Conversion rate
- Revenue per session
- Traffic sources
- User journey

---

#### 3. Instagram ⭐⭐⭐⭐⭐
**Esforço:** Baixo | **Agentes:** Influencers, Marketing

**O que faz:**
- Acesso à Instagram API
- Análise de influencers (followers, engagement)
- Publicação automatizada de posts
- Gestão de DMs
- Tracking de menções e hashtags

**Porquê é crítico:**
- Instagram é o canal principal de vendas
- Instagram Shopping integrado
- Influencers são core da estratégia
- Visual - joias precisam de imagens

**Casos de uso:**
- Agente Influencers: "Analisar perfil @influencer - engagement rate?"
- Agente Marketing: "Publicar post novo às 18h"
- Agente Support: "Responder DM sobre encomenda"
- "Alerta: nova menção da marca"

**Funcionalidades:**
- Instagram Basic Display API
- Instagram Graph API
- Instagram Shopping API
- Webhooks para comentários/mentions

---

### 🟡 PRIORIDADE ALTA (Instalar Depois)

---

#### 4. AgentMail ⭐⭐⭐⭐
**Esforço:** Baixo | **Agentes:** Marketing, Support

**O que faz:**
- Gestão de emails via API
- Envio de emails transacionais
- Templates de email
- Tracking de aberturas/cliques
- Automação de sequências

**Porquê é importante:**
- Email marketing é essencial
- Comunicação com clientes
- Confirmações de encomenda
- Campanhas promocionais

**Integrações:**
- SendGrid
- AWS SES
- Mailgun
- SMTP genérico

---

#### 5. Playwright Scraper ⭐⭐⭐⭐
**Esforço:** Alto | **Agentes:** Análises, Influencers

**O que faz:**
- Web scraping avançado com Playwright
- Automação de browser real
- Extrair dados de sites dinâmicos
- Screenshots e PDFs
- Monitorização de concorrência

**Porquê é importante:**
- Análise de concorrência
- Monitorização de preços
- Pesquisa de mercado
- Dados que não têm API

**Casos de uso:**
- "Verificar preços da concorrência"
- "Extrair lista de influencers de X site"
- "Monitorizar mentions da marca"
- "Screenshot de páginas para relatório"

**Segurança:**
- Respeitar robots.txt
- Rate limiting
- Headers realistas
- Proxy rotation (se necessário)

---

#### 6. Automation Workflows ⭐⭐⭐⭐
**Esforço:** Médio | **Agentes:** Todos

**O que faz:**
- Criar workflows automatizados
- Trigger-action logic
- Integração entre múltiplas ferramentas
- Scheduling de tarefas
- Condições e branching

**Porquê é importante:**
- Automatizar tarefas repetitivas
- Conectar sistemas diferentes
- Workflows de negócio
- Escalar operações

**Exemplos de workflows:**
```yaml
# Exemplo 1: Nova encomenda
Trigger: Nova encomenda Shopify
Actions:
  - Enviar email confirmação (AgentMail)
  - Criar ticket no Support
  - Alertar Operações se stock baixo
  - Adicionar à planilha de Analytics

# Exemplo 2: Novo lead
Trigger: Novo seguidor Instagram
Actions:
  - Analisar perfil
  - Adicionar à base de dados
  - Enviar mensagem de boas-vindas (se influencer)
```

---

### 🟢 PRIORIDADE MÉDIA

---

#### 7. Marketing Skills ⭐⭐⭐
**Esforço:** Baixo | **Agentes:** Marketing

**O que faz:**
- Coleção de skills específicas para marketing
- Copywriting assistance
- SEO optimization
- Social media management
- Campaign planning

**Exemplos de sub-skills:**
- Ad copy generator
- SEO keyword research
- Hashtag generator
- Content calendar planner
- Competitor analysis

---

## 🎯 ORDEM DE IMPLEMENTAÇÃO RECOMENDADA

### Fase 1: Fundação (Semanas 1-2)
1. ✅ Shopify (dados core do negócio)
2. ✅ GA4 Analytics (métricas de performance)
3. ✅ Instagram (canal principal)

### Fase 2: Comunicação (Semanas 3-4)
4. ✅ AgentMail (emails)
5. ✅ WhatsApp Business API (já na lista)

### Fase 3: Automação (Semanas 5-6)
6. ✅ Automation Workflows (conectar tudo)
7. ✅ Playwright Scraper (análise avançada)

### Fase 4: Optimização (Semanas 7-8)
8. ✅ Marketing Skills + Klaviyo
9. ✅ Skills de capacidade (Self-Reflection, etc.)

---

## 🔒 SEGURANÇA - Aplicar a Todas

Para cada skill da lista:

1. ✅ Verificar no VirusTotal antes de instalar
2. ✅ Ler SKILL.md completo
3. ✅ Testar em sandbox primeiro
4. ✅ Configurar permissões mínimas
5. ✅ Ativar audit logging
6. ✅ Documentar instalação

---

## 📊 IMPACTO ESPERADO

Com estas 7 skills instaladas:

| Métrica | Antes | Depois | Melhoria |
|---------|-------|--------|----------|
| Tempo de resposta Support | 12 min | <5 min | -60% |
| Relatórios Analytics | Manual | Automático | +90% eficiência |
| Posts Instagram | Manual | Semi-auto | +50% produtividade |
| Processamento encomendas | Manual | Automatizado | -70% erros |
| Análise concorrência | Não existe | Semanal | Novo |

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

- [ ] Aprovar lista com Rafael
- [ ] Configurar ambiente de teste (sandbox)
- [ ] Verificar segurança de cada skill
- [ ] Instalar Fase 1 (Shopify, GA4, Instagram)
- [ ] Testar integrações
- [ ] Documentar uso
- [ ] Instalar Fase 2
- [ ] ... (seguir fases)

---

**Documento criado por Veci com base nas prioridades definidas pelo Rafael.**

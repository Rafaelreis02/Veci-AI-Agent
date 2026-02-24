# Configuração de Backup e Notion Skill

**Data:** 2026-02-22  
**Criado por:** Veci para Rafael

---

## ✅ PARTE 1: BACKUP AUTOMÁTICO CONFIGURADO!

### O que foi feito:
1. ✅ Git inicializado no workspace
2. ✅ `.gitignore` criado (protege secrets)
3. ✅ Primeiro commit: 54 ficheiros (4980 linhas)
4. ✅ Script de backup automático criado
5. ✅ Cron configurado: backup diário às 2h da manhã

### Estrutura do Backup:
```
/home/moltbot/.openclaw/workspace/
├── AGENTS.md, MEMORY.md, SOUL.md (configuração)
├── memory/ (memória de todos os agentes)
├── skills/ (skills instaladas)
├── scripts/ (automações)
└── .openclaw/backup.log (log de backups)
```

### O que é guardado:
- ✅ Toda a configuração dos agentes
- ✅ Memórias (short-term e long-term)
- ✅ Documentação
- ✅ Scripts e automações
- ✅ Status dos agentes

### O que NÃO é guardado (segurança):
- ❌ Secrets (tokens, passwords)
- ❌ Ficheiros .env
- ❌ Logs temporários
- ❌ Cache

---

## 🔧 COMO CONFIGURAR GITHUB (Para ter backup na nuvem)

### Passo 1: Criar Repositório no GitHub
1. Vai a https://github.com/new
2. Nome: `veci-ai-agent` (ou outro nome)
3. Privado (recomendado - contém dados da empresa)
4. NÃO inicializar com README (já temos)

### Passo 2: Adicionar Remote (comandos para correr no servidor)
```bash
cd /home/moltbot/.openclaw/workspace
git remote add origin https://github.com/RAFAEL-USERNAME/veci-ai-agent.git
```

### Passo 3: Configurar Autenticação (duas opções)

**Opção A: GitHub Token (Recomendado)**
1. Vai a https://github.com/settings/tokens
2. Gera novo token com permissão `repo`
3. Guarda token em 1Password
4. Correr:
```bash
cd /home/moltbot/.openclaw/workspace
git remote set-url origin https://TOKEN@github.com/RAFAEL-USERNAME/veci-ai-agent.git
```

**Opção B: SSH Key**
```bash
ssh-keygen -t ed25519 -C "veci@vecinocustom.com"
cat ~/.ssh/id_ed25519.pub
# Copiar chave pública para GitHub → Settings → SSH Keys
git remote set-url origin git@github.com:RAFAEL-USERNAME/veci-ai-agent.git
```

### Passo 4: Primeiro Push
```bash
cd /home/moltbot/.openclaw/workspace
git push -u origin master
```

### Passo 5: Verificar Backup Automático
```bash
# Verificar se cron está ativo
sudo systemctl status cron

# Ver log do backup
tail -f /home/moltbot/.openclaw/workspace/.openclaw/backup.log

# Forçar backup manual
/home/moltbot/.openclaw/workspace/scripts/backup-diario.sh
```

---

## 📋 COMO RECUPERAR (Se algo correr mal)

### Cenário 1: Perdi um ficheiro específico
```bash
cd /home/moltbot/.openclaw/workspace
git checkout HEAD -- memory/agents/marketing/status.json
```

### Cenário 2: Quero voltar ao estado de ontem
```bash
cd /home/moltbot/.openclaw/workspace
git log --oneline -10  # ver histórico
git checkout HEAD~1    # voltar 1 commit atrás
# ou
git reset --hard HEAD~1  # reset completo
```

### Cenário 3: Migrar para novo servidor
```bash
# No novo servidor
git clone https://github.com/RAFAEL-USERNAME/veci-ai-agent.git
# Restaurar secrets (manualmente de 1Password)
# Reiniciar serviços
```

---

## ✅ PARTE 2: NOTION SKILL

### Porquê Notion?

| Vantagem | Descrição |
|----------|-----------|
| **All-in-one** | Docs, DB, Wiki, Tasks num só sítio |
| **Visual** | Fácil de usar para equipa |
| **API boa** | Integração fácil com agentes |
| **Colaborativo** | Rafael + Alice + Agentes |
| **Templates** | Criar sistemas rapidamente |

### Casos de Uso por Agente:

#### Veci (Coordenador)
- **Dashboard geral** - Estado de todos os agentes
- **Relatórios diários** - Páginas auto-geradas
- **Decisions log** - Registo de decisões importantes

#### Marketing
- **Calendário editorial** - Posts, campanhas, datas
- **Briefings** - Informação de cada campanha
- **Performance** - Métricas de cada iniciativa

#### Influencers
- **Database de creators** - Nome, seguidores, contacto, estado
- **Pipeline** - Proposta → Negociação → Contrato
- **Campanhas** - Quem participou, resultados

#### Support
- **FAQ** - Respostas a perguntas frequentes
- **Templates** - Mensagens de resposta
- **Escalations** - Casos que precisam de Rafael

#### Operações
- **Inventário** - Stock, fornecedores, prazos
- **Processos** - SOPs, checklists
- **Fornecedores** - Contactos, condições

#### Análises
- **Dashboards** - KPIs, gráficos
- **Relatórios** - Diários, semanais, mensais
- **Alertas** - Anomalias, thresholds

### Estrutura Proposta no Notion:

```
📦 Vecinocustom AI Agents
├── 📊 Dashboard
│   ├── Estado dos Agentes
│   ├── Métricas de Hoje
│   └── Alertas
├── 📅 Marketing
│   ├── Calendário Editorial
│   ├── Campanhas
│   └── Briefings
├── 👥 Influencers
│   ├── Database
│   ├── Pipeline
│   └── Campanhas
├── 🎧 Support
│   ├── FAQ
│   ├── Templates
│   └── Tickets
├── 📦 Operações
│   ├── Inventário
│   ├── Fornecedores
│   └── Processos
├── 📈 Análises
│   ├── Dashboards
│   ├── Relatórios
│   └── Previsões
└── 💻 Programadores
    ├── Roadmaps
    ├── Documentação
    └── Tasks
```

### Como Funcionaria:

**Exemplo 1 - Relatório Diário:**
```
Eu (Veci) às 8h:
1. Recolho dados de todos os agentes
2. Gero relatório
3. Crio página no Notion "Relatório 2026-02-22"
4. Rafael vê ao pequeno-almoço
5. Comenta diretamente na página
6. Eu aprendo com o feedback
```

**Exemplo 2 - Pipeline de Influencers:**
```
Agente Influencers:
1. Encontra novo creator
2. Adiciona ao Notion Database
3. Status: "Para contactar"
4. Envia email automaticamente
5. Atualiza status: "Contactado"
6. Rafael vê no Notion
```

### Implementação Técnica:

**Skill: notion-api**
```yaml
name: notion-integration
type: integration
permissions:
  - read: databases, pages
  - write: databases, pages
  - create: pages, databases
config:
  token: op://notion/api-token  # em 1Password
  workspace: vecinocustom
```

**Operações suportadas:**
- Criar/editar páginas
- Query databases
- Adicionar items a databases
- Criar relatórios formatados
- Upload de imagens/ficheiros

---

## 🎯 RECOMENDAÇÃO FINAL

### Prioridade:
1. ✅ **Configurar GitHub** (backup imediato) - 30 minutos
2. ✅ **Instalar Notion** - 1-2 horas de setup
3. ✅ **Testar integrações** - 1 hora

### Ordem de Implementação:
```
Esta semana:
├── Configurar GitHub backup
├── Criar estrutura Notion
└── Instalar skill Notion

Próxima semana:
├── Criar templates de páginas
├── Automatizar relatórios diários
└── Integrar com outros agentes
```

### Custo:
- **GitHub:** Gratuito (repositório privado)
- **Notion:** Free plan (suficiente para começar) ou Plus ($8/mês)

---

## 📚 RECURSOS

### Git:
- GitHub: https://github.com/new
- Token: https://github.com/settings/tokens
- Docs: https://docs.github.com

### Notion:
- Notion: https://notion.so
- API: https://developers.notion.com
- Templates: https://notion.so/templates

---

**Documento criado por Veci para garantir continuidade e organização.**

🧠 **Lembrete:** "Backup é como um pára-quedas - se precisares e não tiveres, nunca mais vais precisar de outra coisa."

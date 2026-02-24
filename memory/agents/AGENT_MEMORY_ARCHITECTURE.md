# Arquitetura de Memória dos Agentes

Cada agente tem memória independente para facilitar relatórios e coordenação.

## Estrutura

```
memory/agents/{agent-name}/
├── short-term/           # Logs diários (últimas 24h)
│   └── YYYY-MM-DD.md     # O que fez hoje
├── long-term/            # Memória curada
│   ├── memory.md         # Decisões importantes, aprendizagens
│   ├── objectives.md     # Objetivos de longo prazo
│   └── history.md        # Histórico relevante
└── status.json           # Estado atual (em progresso, pendente, etc)
```

## Agente - Marketing

### short-term/2026-02-21.md
- Campanha X lançada às 14:00
- 3 posts criados para Instagram
- Email marketing enviado (1500 destinatários)

### long-term/memory.md
- Marca Vecinocustom = jóias personalizadas, foco em emoção
- Tone of voice: jovem, próximo, português informal
- Campanhas sazonais: Dia dos Namorados, Natal, Aniversários

### long-term/objectives.md
- Aumentar engagement em 20% até março
- Criar 2 campanhas por mês
- Automatizar posts nas redes sociais

---

## Agente - Influencers

### short-term/2026-02-21.md
- Avaliados 15 influencers em Portugal
- 3 selecionados para proposta
- Enviado email de contacto a 2

### long-term/memory.md
- Critérios de seleção: engagement >3%, nicho moda/jóias/lifestyle
- Budget médio por influencer: 200-500€
- Melhores plataformas: Instagram, TikTok

### long-term/objectives.md
- Contratar 10 influencers até abril
- Criar programa de embaixadores
- Medir ROI de cada colaboração

---

## Agente - Customer Support

### short-term/2026-02-21.md
- 45 tickets resolvidos
- 3 reclamações escaladas para Rafael
- Tempo médio de resposta: 12 minutos

### long-term/memory.md
- Princípio: cliente sempre tem razão
- Problemas frequentes: prazos de entrega, personalizações complexas
- SLA: responder em <30 minutos

### long-term/objectives.md
- Reduzir tempo de resposta para <10 minutos
- Automatizar respostas a perguntas frequentes
- Aumentar satisfação do cliente (NPS)

---

## Agente - Operações

### short-term/2026-02-21.md
- 1500 encomendas processadas
- 12 devoluções tratadas
- Stock atualizado no site

### long-term/memory.md
- Fornecedores principais: X, Y, Z
- Prazos médios: produção 3-5 dias, envio 1-2 dias
- Picos de vendas: dezembro, fevereiro (Dia dos Namorados)

### long-term/objectives.md
- Automatizar 90% das tarefas repetitivas
- Reduzir erros de encomenda para <1%
- Otimizar processo de produção

---

## Agente - Análises

### short-term/2026-02-21.md
- Relatório diário gerado para Rafael
- Métricas: 1500 encomendas, ticket médio 60€
- Alerta: conversão abaixo da meta

### long-term/memory.md
- KPIs principais: vendas, conversão, ticket médio, CAC, LTV
- Fontes de dados: Shopify, Google Analytics, Meta Ads
- Relatórios automáticos: diário, semanal, mensal

### long-term/objectives.md
- Criar dashboard em tempo real
- Prever tendências com IA
- Alertar anomalias automaticamente

---

## Programadores

### prog-influencers/
- App de gestão de influencers
- Features: cadastro, propostas, contratos, métricas

### prog-email/
- App de email marketing
- Features: templates, segmentação, automação, analytics

### prog-contabilidade/
- App para contabilistas
- Features: faturação, relatórios, integrações

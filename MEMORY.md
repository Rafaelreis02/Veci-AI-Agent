# MEMORY.md - O Que Lembro

## Empresa

- **Vendas:** only website (www.vecinocustom.com)
- **Encomendas:** ~1500/mês
- **Ticket médio:** 60€
- **Equipa:** Only Rafael + Alice por agora
- **Tech stack:** Vercel, GitHub, Supabase/Neon.tech

## Objetivos

- Automação total
- Minimizar erros
- Eficiência máxima
- "Quase instantaneamente" - sense of urgency

## Agentes Planeados

1. Marketing - campanhas, conteúdo, anúncios, emails
2. Influencers - *(já criado)* avaliação e sugestão de influencers
3. Customer Support - apoio, reclamações, empatia
4. Operações - tarefas repetitivas
5. Análises - relatórios, métricas consolidadas
6. Prog. Influencers - app gestão influencers
7. Prog. Email Marketing - app gestão email
8. Prog. Contabilidade - app para contabilistas

## Arquitetura de Memória dos Agentes

Cada agente tem memória independente:
- **short-term/**: Logs diários (últimas 24h)
- **long-term/**: Memória curada + objetivos
- **status.json**: Estado atual em tempo real

Local: `memory/agents/{nome-agente}/`

### Função de Relatórios (Veci)

Eu recolho informação de todos os agentes:
1. Leio `short-term/YYYY-MM-DD.md` de cada agente
2. Consolido em relatório diário para Rafael
3. Identifico bloqueios, progresso e próximos passos
4. Atualizo `long-term/memory.md` quando necessário

## Notas

- Quero que os agentes tenham personalidades distintas
- Primeiro: configurar-me a mim (skills, ficheiros)
- Depois: criar agentes com características
- Finalmente: trabalhar nos projetos

---

Guardado em 2026-02-21

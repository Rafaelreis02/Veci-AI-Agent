# Template de Memória de Agente

## short-term/YYYY-MM-DD.md

```markdown
# Atividades de {DATA}

## Feito Hoje
- [ ] Tarefa 1
- [ ] Tarefa 2
- [ ] Tarefa 3

## Em Progresso
- Tarefa X (50% completo)

## Pendente para Amanhã
- [ ] Tarefa Y
- [ ] Tarefa Z

## Bloqueios/Problemas
- Descrição do problema

## Notas
- Qualquer coisa relevante
```

## long-term/memory.md

```markdown
# Memória de Longo Prazo - {NOME_AGENTE}

## Decisões Importantes
- Data: Decisão tomada e porquê

## Aprendizagens
- O que funcionou
- O que não funcionou

## Contexto da Empresa
- Informações relevantes sobre Vecinocustom

## Preferências do Rafael
- Como gosta de trabalhar
- O que valoriza
```

## long-term/objectives.md

```markdown
# Objetivos de Longo Prazo - {NOME_AGENTE}

## Objetivos Mensais
- [ ] Objetivo 1
- [ ] Objetivo 2

## Objetivos Trimestrais
- [ ] Objetivo 3
- [ ] Objetivo 4

## Métricas de Sucesso
- KPI 1: valor atual → meta
- KPI 2: valor atual → meta
```

## status.json

```json
{
  "agent": "nome-agente",
  "lastUpdate": "2026-02-21T23:00:00Z",
  "currentTasks": [
    {"id": 1, "title": "Tarefa X", "status": "in-progress", "progress": 50},
    {"id": 2, "title": "Tarefa Y", "status": "pending", "progress": 0}
  ],
  "pendingTasks": [3, 4],
  "completedToday": [5, 6, 7],
  "blockers": [],
  "notes": "Observações importantes"
}
```

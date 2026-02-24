---
name: brave-search
description: "Pesquisar na web usando Brave Search API. Use quando: precisas de informação atualizada, notícias, pesquisar sobre produtos, empresas, tendências, ou qualquer coisa que exija dados da internet. Not for: informações internas da empresa ou dados pessoais."
---

# Brave Search Skill

## Quando Usar

✅ **USE esta skill quando:**
- "Pesquisa sobre [tópico]"
- "O que dizem sobre [marca/produto]?"
- "Notícias sobre [tema]"
- "Melhor [produto] para [uso]"
- "Quanto custa [produto]"
- "Como fazer [algo]"
- Qualquer coisa que precise de info atualizada da internet

## Como Usar

Usa a ferramenta `web_search` com os parâmetros:
- `query`: O que pesquisar
- `count`: Número de resultados (1-10, padrão 5)
- `freshness`: Filters temporais:
  - `pd` = past day (últimas 24h)
  - `pw` = past week
  - `pm` = past month
  - `py` = past year
- `country`: Código país (ex: "PT" para Portugal)

## Exemplos

```python
# Pesquisar tendências de jóias personalizadas
web_search(query="jewelry trends 2026", count=5, country="PT")

# Notícias sobre e-commerce em Portugal
web_search(query="e-commerce Portugal 2026", freshness="pm", country="PT")

# Pesquisar influencers de moda em Portugal
web_search(query="fashion influencers Portugal Instagram 2026", count=10)
```

## Notas

- Resultados incluem título, URL e snippet
- Bom para pesquisa rápida e recente
- Para pesquisa mais profunda, combina com web_fetch

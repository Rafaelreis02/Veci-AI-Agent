# Mapeamento de Agentes para Tópicos do Telegram

## Estrutura dos Tópicos

| Tópico ID | Nome do Tópico | Agente Associado |
|-----------|----------------|------------------|
| 2 | Main | Veci (eu - coordenador) |
| 3 | Marketing | marketing |
| 4 | Influencers | influencers |
| 5 | Support | customer-support |
| 6 | Ops | operacoes |
| 7 | Reports | analises |
| 8 | Dev - Influencers | prog-influencers |
| 9 | Dev - Email MKT | prog-email |
| 10 | Dev - Contai | prog-contabilidade |

## Como Funciona

Cada agente:
1. **Só responde no seu tópico** (ex: marketing só no tópico 3)
2. **Tem acesso à sua memória** em `memory/agents/{nome}/`
3. **Reporta a mim (Veci)** quando necessário
4. **Pode ser chamado por nome** no tópico correto

## Exemplo de Uso

- Falar no tópico "Marketing" (3) → Agente Marketing responde
- Falar no tópico "Influencers" (4) → Agente Influencers responde
- Falar no tópico "Main" (2) → Eu (Veci) respondo

## Comandos

Para ativar um agente no seu tópico:
```
@VecinoCustomBot ativar agente marketing
```

Para ver estado de um agente:
```
@VecinoCustomBot status marketing
```
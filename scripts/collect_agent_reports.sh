#!/bin/bash
# Script para Veci recolher relatórios de todos os agentes
# Uso: ./collect_agent_reports.sh [data]

data=${1:-$(date +%Y-%m-%d)}
echo "# Relatório Diário - Agentes Vecinocustom"
echo "Data: $data"
echo ""

for agent_dir in /home/moltbot/.openclaw/workspace/memory/agents/*/; do
    agent_name=$(basename "$agent_dir")
    
    # Ignorar ficheiros (só diretórios de agentes)
    if [[ "$agent_name" == *".md" ]] || [[ "$agent_name" == "TEMPLATE" ]]; then
        continue
    fi
    
    echo "## $agent_name"
    echo ""
    
    # Verificar se existe log do dia
    short_term_file="${agent_dir}short-term/${data}.md"
    if [ -f "$short_term_file" ]; then
        echo "### Atividades de Hoje:"
        grep -E "^- \[x\]" "$short_term_file" | head -10 || echo "- Nenhuma atividade registada"
        echo ""
        
        # Verificar bloqueios
        if grep -q "## Bloqueios" "$short_term_file"; then
            echo "### ⚠️ Bloqueios:"
            sed -n '/## Bloqueios/,/##/p' "$short_term_file" | grep "^-" | head -5
            echo ""
        fi
        
        # Verificar pendentes
        if grep -q "## Pendente" "$short_term_file"; then
            echo "### 📋 Pendentes:"
            sed -n '/## Pendente/,/##/p' "$short_term_file" | grep "^- \[ \]" | head -5
            echo ""
        fi
    else
        echo "- Sem registo para hoje"
        echo ""
    fi
    
    # Verificar status.json
    status_file="${agent_dir}status.json"
    if [ -f "$status_file" ]; then
        echo "### Status Atual:"
        jq -r '.currentTasks[] | "- \(.title): \(.status) (\(.progress)%)"' "$status_file" 2>/dev/null | head -5 || echo "- Sem tarefas registadas"
        echo ""
    fi
    
    echo "---"
    echo ""
done

echo "## Resumo Geral"
echo ""
echo "Total de agentes ativos: $(ls -d /home/moltbot/.openclaw/workspace/memory/agents/*/ 2>/dev/null | wc -l)"
echo "Relatório gerado por: Veci 🧠"
echo "Data: $(date)"

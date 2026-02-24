# Plano de Implementação - Influencer Import/Discovery

## Ficheiros a Criar/Modificar:

### 1. API Routes (Novos)
- `src/app/api/influencers/import/route.ts` - Importar handle específico (Scott)
- `src/app/api/prospector/run/route.ts` - Executar influencer-prospector.js

### 2. Componentes (Novos)
- `src/components/ImportInfluencerModal.tsx` - Modal principal com 2 tabs
- `src/components/ImportHandleTab.tsx` - Tab 1: Importar handle
- `src/components/DiscoverByLanguageTab.tsx` - Tab 2: Descobrir por idioma

### 3. Componentes (Remover)
- `src/components/AddProspectModal.tsx` - ❌ Obsoleto

### 4. Páginas (Modificar)
- `src/app/dashboard/influencers/page.tsx` - Atualizar botão "Novo Influencer"

## Configuração:
- Máximo: 50 influencers
- Progresso: Simples (loading → resultado)
- Tabs: Importar Handle | Descobrir por Idioma

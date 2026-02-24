# 🔄 CONFIGURAR IMPORTAÇÃO SEM OPENCW (APENAS APIs)

## 🎯 Opção 1: Usar Apify (Recomendada)

Em vez de usar o script `auto-import-influencers.js` (que usa OpenClaw browser), podes usar o endpoint `/api/worker/analyze-influencer` que usa **Apify** (API paga) + **Gemini** (IA).

### ✅ Vantagens:
- **Não precisa de OpenClaw** nem de mim (agente)
- **Mais fiável** - APIs oficiais em vez de scraping de browser
- **Escalável** - pode processar múltiplos influencers em paralelo
- **Dados mais ricos** - Apify extrai mais informação que o browser snapshot

### ❌ Desvantagens:
- **Custo** - Apify cobra por scraping (mas tem créditos gratuitos)
- **Limites de rate** - APIs têm limites de requests

---

## 🛠️ Como Configurar:

### PASSO 1: Criar novo script de importação (sem OpenClaw)

Cria `scripts/auto-import-apify.js`:

```javascript
#!/usr/bin/env node
/**
 * AUTO-IMPORT VIA APIFY (Sem OpenClaw)
 * 
 * Este script substitui o auto-import-influencers.js
 * Não usa browser/openclaw - apenas APIs
 */

const fetch = require('node-fetch');

const API_BASE = process.env.VECINO_API_URL || 'https://vecinocustom-influencer-platform.vercel.app';
const API_TOKEN = process.env.SCOTT_API_TOKEN; // Mesmo token do Scott

async function main() {
  console.log('🤖 Auto-Import Apify (Sem OpenClaw)');
  
  try {
    // 1. Buscar influencers pendentes
    const pendingRes = await fetch(`${API_BASE}/api/worker/pending`);
    const pending = await pendingRes.json();
    
    if (!pending.length) {
      console.log('✅ Nenhum influencer pendente');
      return;
    }
    
    console.log(`📋 ${pending.length} influencers pendentes`);
    
    // 2. Processar cada um
    for (const influencer of pending) {
      const handle = (influencer.tiktokHandle || influencer.instagramHandle || '').replace('@', '');
      const platform = influencer.tiktokHandle ? 'TIKTOK' : 'INSTAGRAM';
      
      console.log(`\n🔍 Analisando @${handle}...`);
      
      try {
        // Chamar API de análise (Apify + Gemini)
        const analyzeRes = await fetch(`${API_BASE}/api/worker/analyze-influencer`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${API_TOKEN}`,
          },
          body: JSON.stringify({ handle, platform }),
        });
        
        if (!analyzeRes.ok) {
          console.error(`❌ Erro na análise: ${await analyzeRes.text()}`);
          continue;
        }
        
        const analysis = await analyzeRes.json();
        
        // 3. Atualizar influencer na DB
        const updateRes = await fetch(`${API_BASE}/api/influencers/${influencer.id}`, {
          method: 'PATCH',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            status: 'SUGGESTION',
            tiktokFollowers: analysis.followers,
            engagementRate: analysis.engagement,
            averageViews: analysis.averageViews,
            estimatedPrice: analysis.estimatedPrice,
            fitScore: analysis.fitScore,
            niche: analysis.niche,
            tier: analysis.tier,
            biography: analysis.biography,
            avatarUrl: analysis.avatar,
            email: analysis.email,
            country: analysis.country,
            notes: `[APIFY AUTO-IMPORT]\n\n${analysis.summary}\n\nPontos Fortes:\n${analysis.strengths?.map(s => `• ${s}`).join('\n') || 'N/A'}`,
          }),
        });
        
        if (updateRes.ok) {
          console.log(`✅ @${handle} importado! Fit: ${analysis.fitScore}/5`);
        } else {
          console.error(`❌ Erro ao atualizar: ${await updateRes.text()}`);
        }
        
        // Rate limiting gentil (2s entre pedidos)
        await new Promise(r => setTimeout(r, 2000));
        
      } catch (error) {
        console.error(`❌ Erro processando @${handle}: ${error.message}`);
      }
    }
    
    console.log('\n✨ Done!');
    
  } catch (error) {
    console.error('❌ Erro:', error);
    process.exit(1);
  }
}

main();
```

---

### PASSO 2: Configurar Cron Job (Vercel)

Em vez de Windows Task Scheduler, usa **Vercel Cron**:

```json
// vercel.json
{
  "crons": [
    {
      "path": "/api/cron/auto-import",
      "schedule": "0 */6 * * *"
    }
  ]
}
```

Cria `src/app/api/cron/auto-import/route.ts`:

```typescript
import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { parseProfile } from '@/lib/apify-fetch';
import { logger } from '@/lib/logger';

// Esta API é chamada pelo Vercel Cron a cada 6 horas
export async function GET(request: Request) {
  // Verificar secret
  const authHeader = request.headers.get('authorization');
  if (authHeader !== `Bearer ${process.env.CRON_SECRET}`) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }
  
  try {
    // Buscar pendentes
    const pending = await prisma.influencer.findMany({
      where: {
        status: 'IMPORT_PENDING',
        OR: [
          { tiktokHandle: { not: null } },
          { instagramHandle: { not: null } },
        ],
      },
      take: 5, // Processa max 5 de cada vez
    });
    
    const results = [];
    
    for (const influencer of pending) {
      const handle = (influencer.tiktokHandle || influencer.instagramHandle || '').replace('@', '');
      const platform = influencer.tiktokHandle ? 'TIKTOK' : 'INSTAGRAM';
      
      try {
        // Usar Apify (não OpenClaw!)
        const profile = await parseProfile(handle, platform);
        
        // Atualizar na DB
        await prisma.influencer.update({
          where: { id: influencer.id },
          data: {
            status: 'SUGGESTION',
            tiktokFollowers: profile.followers,
            engagementRate: profile.engagementRate,
            averageViews: profile.averageViews,
            estimatedPrice: profile.estimatedPrice,
            biography: profile.biography,
            avatarUrl: profile.avatar,
            // ... outros campos
          },
        });
        
        results.push({ handle, success: true });
        
        // Rate limiting
        await new Promise(r => setTimeout(r, 2000));
        
      } catch (error) {
        results.push({ handle, success: false, error: error.message });
      }
    }
    
    logger.info('Cron auto-import completed', { processed: results.length });
    return NextResponse.json({ success: true, results });
    
  } catch (error) {
    logger.error('Cron auto-import failed', error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
```

---

### PASSO 3: Alternativa - Usar o Scott

O `scripts/scott-api.js` **já funciona sem OpenClaw**!

```bash
# Em vez de:
node scripts/auto-import-influencers.js  # ← Usa OpenClaw

# Usa:
node scripts/scott-api.js  # ← Usa apenas APIs (Apify + Gemini)
```

O Scott:
- ✅ Não usa `openclaw browser`
- ✅ Usa Apify para scraping
- ✅ Usa Gemini para análise
- ✅ Chama APIs HTTP normais

---

## 📊 COMPARAÇÃO

| Método | Usa OpenClaw? | Tecnologia | Custo | Fiabilidade |
|--------|--------------|------------|-------|-------------|
| `auto-import-influencers.js` | ✅ Sim | Browser scraping | Grátis | Média (pode falhar se TikTok mudar) |
| `scott-api.js` | ❌ Não | Apify + Gemini | Pago (Apify) | Alta (APIs oficiais) |
| Vercel Cron | ❌ Não | Apify | Pago | Alta |
| API manual | ❌ Não | Apify | Pago | Alta |

---

## 🎯 RESUMO

Para **não usar o OpenClaw/agente** na importação:

1. **Mais fácil:** Usar o script `scripts/scott-api.js` (já existe e funciona!)
2. **Automático:** Configurar Vercel Cron com `/api/cron/auto-import`
3. **Manual:** Chamar `/api/worker/analyze-influencer` via dashboard ou API

**Nota:** O Apify tem custos, mas é mais fiável que scraping de browser. O sistema atual tem créditos gratuitos do Apify que podem ser suficientes para começar.

Queres que eu configure uma destas opções? 🚀

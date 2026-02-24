# 🎯 PROCESSO DE PESQUISA DE INFLUENCERS

**Documento:** Workflow de Prospeção de Influencers  
**Plataforma:** VecinoCustom Influencer Platform  
**Última atualização:** 2026-02-22  
**Responsável:** Agente Influencers

---

## 📋 VISÃO GERAL

Fazemos **2 pesquisas diárias** para encontrar influencers em **6 países**:
- 🇬🇧 Inglaterra (UK)
- 🇩🇪 Alemanha (DE)
- 🇫🇷 França (FR)
- 🇵🇹 Portugal (PT)
- 🇮🇹 Itália (IT)
- 🇪🇸 Espanha (ES)

**Stack:**
- **Apify** → Scraping de dados TikTok
- **Gemini AI** → Análise e scoring de influencers
- **Neon.tech (PostgreSQL)** → Base de dados
- **Next.js App** → Interface de gestão

---

## 🔐 CREDENCIAIS NECESSÁRIAS

As credenciais estão no **1Password**:

| Serviço | Item no 1Password | Variável |
|---------|------------------|----------|
| Apify API Token | `Apify API Token` | `APIFY_API_TOKEN` |
| Neon.tech Database URL | `Neon.tech - VecinoCustom` | `DATABASE_URL` |
| Gemini API Key | `Google Gemini API` | `GEMINI_API_KEY` |

### Para aceder via 1Password CLI:
```bash
# Apify Token
op read op://Personal/Apify/credential

# Database URL
op read op://Personal/Neon.tech/DATABASE_URL

# Gemini Key
op read op://Personal/Gemini/API_KEY
```

---

## 🗄️ ESTRUTURA DA BASE DE DADOS

### Tabela Principal: `Influencer`

```prisma
model Influencer {
  id                String   @id @default(cuid())
  name              String
  email             String?
  phone             String?
  
  // Social Media
  instagramHandle   String?
  instagramFollowers Int?
  tiktokHandle      String?
  tiktokFollowers   Int?
  youtubeHandle     String?
  youtubeFollowers  Int?
  avatarUrl         String?
  
  // Metrics
  totalLikes        BigInt?
  engagementRate    Float?
  averageViews      String?     // Ex: "3K-30K"
  contentStability  String?     // HIGH, MEDIUM, LOW
  
  // Demographics
  country           String?     // PT, ES, EN, DE, FR, IT
  language          String?     // Idioma principal
  niche             String?     // Fashion, Lifestyle, etc.
  contentTypes      String[]    // ["Hauls", "Unboxings"]
  primaryPlatform   String?     // TikTok, Instagram
  biography         String?
  verified          Boolean?    @default(false)
  videoCount        Int?
  
  // Business
  estimatedPrice    Float?      // Preço estimado
  fitScore          Int?        // 1-5 score para joias
  
  // Status
  status            InfluencerStatus @default(IMPORT_PENDING)
  
  // AI Analysis
  analysisSummary   String?     // Resumo da análise Gemini
  analysisDate      DateTime?
  
  // Discovery
  discoveryMethod   String?     // MANUAL ou AUTOMATED
  discoveryDate     DateTime?
  
  createdAt         DateTime    @default(now())
  updatedAt         DateTime    @updatedAt
}
```

### Status dos Influencers

| Status | Emoji | Significado |
|--------|-------|-------------|
| `IMPORT_PENDING` | ⏳ | A ser analisado pelo agente |
| `ANALYZING` | 🔎 | Em análise de proposta |
| `SUGGESTION` | 💡 | Sugestão da IA |
| `AGREED` | 🤝 | Valores acordados |
| `COMPLETED` | ✅ | Parceria concluída |
| `BLACKLISTED` | 🚫 | Bloqueado |

---

## 🔄 WORKFLOW DE PESQUISA

### Passo 1: Pesquisa no Apify

**Actor ID:** `GdWCkxBtKWOsKjdch` (Free TikTok Scraper)

**Tipos de pesquisa:**

#### A) Por Perfil (mais comum)
```javascript
{
  profiles: ["https://www.tiktok.com/@username"],
  resultsPerPage: 10
}
```

#### B) Por Hashtag (descoberta)
```javascript
{
  hashtags: ["jewelry", "fashion", "aesthetic"],
  resultsPerPage: 100
}
```

**Output do Apify:**
- 10 items tipo **POST** (vídeos)
- 10 items tipo **AUTHOR** (dados do perfil)

**Campos importantes (são strings flat!):**
- `authorMeta.fans` → followers
- `authorMeta.verified` → verified
- `authorMeta.signature` → biography
- `authorMeta.video` → videoCount
- `webVideoUrl` → URL do vídeo
- `playCount` → views
- `diggCount` → likes

### Passo 2: Análise com Gemini

**Prompt para análise:**
```
You are an expert influencer analyst for VecinoCustom, a brand specializing 
in personalized jewelry (custom necklaces, bracelets, rings with names).

Analyze this TikTok influencer and assess their fit for a brand partnership.

Profile: @handle
Followers: X
Engagement: X%
Bio: X

Recent Videos:
[lista dos últimos 10 vídeos]

Return JSON with:
- fitScore (1-5)
- niche (fashion, lifestyle, jewelry, etc.)
- country (PT, ES, EN, DE, FR, IT)
- language (PT, ES, EN, DE, FR, IT)
- contentTypes (array)
- strengths (array)
- concerns (array)
- estimatedPrice (range in €)
```

### Passo 3: Guardar na Base de Dados

**SQL de inserção:**
```sql
INSERT INTO influencers (
  id, name, tiktokHandle, tiktokFollowers, 
  engagementRate, country, language, niche,
  fitScore, status, discoveryMethod, 
  analysisSummary, discoveryDate
) VALUES (
  gen_random_uuid(),
  'Nome do Influencer',
  '@handle',
  150000,
  4.5,
  'PT',
  'PT',
  'Fashion',
  4,
  'IMPORT_PENDING',
  'AUTOMATED',
  'Resumo da análise Gemini...',
  NOW()
);
```

---

## 🌍 ESTRATÉGIA POR PAÍS

### 🇵🇹 PORTUGAL (PT)
**Hashtags populares:**
- `#modapt` `#fashionpt` `#estilopt`
- `#joias` `#joiaspersonalizadas` `#acessorios`
- `#portugal` `#portuguesas` `#tugas`

**Critérios:**
- Min 10K followers
- Engagement >3%
- Idade: 18-35 anos

### 🇪🇸 ESPANHA (ES)
**Hashtags populares:**
- `#moda` `#fashionespaña` `#estilo`
- `#joyas` `#joyaspersonalizadas` `#bisuteria`
- `#españa` `#spain` `#españolas`

**Critérios:**
- Min 20K followers
- Engagement >2.5%
- Foco em Madrid/Barcelona

### 🇬🇧 INGLATERRA (UK)
**Hashtags populares:**
- `#fashionuk` `#ukfashion` `#style`
- `#jewelry` `#personalizedjewelry` `#accessories`
- `#uk` `#unitedkingdom` `#london`

**Critérios:**
- Min 30K followers
- Engagement >2%
- English content only

### 🇩🇪 ALEMANHA (DE)
**Hashtags populares:**
- `#mode` `#fashiondeutschland` `#stil`
- `#schmuck` `#personalisierterschmuck`
- `#deutschland` `#germany` `#berlin`

**Critérios:**
- Min 25K followers
- Engagement >2.5%
- German-speaking

### 🇫🇷 FRANÇA (FR)
**Hashtags populares:**
- `#mode` `#fashionfrance` `#style`
- `#bijoux` `#bijouxpersonnalises`
- `#france` `#paris` `#francaise`

**Critérios:**
- Min 25K followers
- Engagement >2.5%
- French-speaking

### 🇮🇹 ITÁLIA (IT)
**Hashtags populares:**
- `#moda` `#fashionitalia` `#stile`
- `#gioielli` `#gioiellipersonalizzati`
- `#italia` `#italy` `#milano`

**Critérios:**
- Min 20K followers
- Engagement >2.5%
- Italian-speaking

---

## 📝 CHECKLIST DIÁRIO (2 Pesquisas)

### Pesquisa #1 (Manhã)
- [ ] Escolher 2 países para focar
- [ ] Definir 3-5 hashtags relevantes
- [ ] Correr Apify scraper
- [ ] Analisar resultados com Gemini
- [ ] Inserir na base de dados
- [ ] Atualizar relatório de progresso

### Pesquisa #2 (Tarde)
- [ ] Escolher 2 países diferentes
- [ ] Repetir processo de pesquisa
- [ ] Verificar duplicados antes de inserir
- [ ] Priorizar influencers com fitScore >= 4

---

## ⚙️ SCRIPTS ÚTEIS

### Verificar duplicados:
```sql
SELECT tiktokHandle, COUNT(*) 
FROM influencers 
WHERE tiktokHandle = '@handle'
GROUP BY tiktokHandle;
```

### Listar influencers pendentes:
```sql
SELECT name, tiktokHandle, country, fitScore, status
FROM influencers
WHERE status = 'IMPORT_PENDING'
ORDER BY fitScore DESC, discoveryDate DESC;
```

### Estatísticas por país:
```sql
SELECT 
  country,
  COUNT(*) as total,
  AVG(fitScore) as avg_score,
  AVG(engagementRate) as avg_engagement
FROM influencers
WHERE discoveryDate >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY country;
```

---

## 🎯 CRITÉRIOS DE SELEÇÃO

### ✅ BOM CANDIDATO (fitScore 4-5)
- Engagement rate >3%
- Nicho: Fashion, Lifestyle, Jewelry
- Conteúdo estético/coerente
- Audiência feminina 18-35
- Posts regulares (último <7 dias)
- Bio profissional/contato visível

### ⚠️ CANDIDATO MÉDIO (fitScore 3)
- Engagement 2-3%
- Nicho relacionado mas não exato
- Conteúdo misto
- Audiência mais variada

### ❌ NÃO SELECIONAR (fitScore 1-2)
- Engagement <2%
- Conteúdo não relacionado
- Perfil privado
- Pouca atividade (<1 post/semana)
- Audiência demasiado jovem (<18)

---

## 🚀 PRÓXIMOS PASSOS

1. **Configurar acesso ao 1Password** → Obter tokens
2. **Testar conexão Apify** → Validar actor
3. **Testar conexão Neon** → Validar DB
4. **Fazer primeira pesquisa** → PT ou ES
5. **Criar relatório diário** → Enviar ao Rafael

---

**Notas:**
- Sempre verificar duplicados antes de inserir
- Priorizar qualidade sobre quantidade
- Atualizar status assim que houver contacto
- Guardar screenshots/links dos melhores perfis

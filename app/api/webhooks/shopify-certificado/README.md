# Webhook Certificado de Exportação

Adiciona automaticamente o link do certificado de exportação às encomendas do Shopify quando são criadas.

## Como funciona

1. Shopify dispara webhook `orders/create` → Este endpoint
2. Endpoint extrai o número da encomenda
3. Adiciona:
   - **Metafield**: `certificado_exportacao.link` com o URL completo
   - **Nota**: Visível no admin do Shopify

## Setup

### 1. Configurar variáveis de ambiente

```bash
# Copiar exemplo
cp .env.local.example .env.local

# Editar com valores reais (já estão no 1Password)
```

### 2. Deploy no Vercel

```bash
# Instalar Vercel CLI se necessário
npm i -g vercel

# Login e deploy
vercel --prod
```

### 3. Configurar Webhook no Shopify

1. Ir a **Settings** → **Notifications** → **Webhooks**
2. Criar novo webhook:
   - **Event**: `Order creation`
   - **URL**: `https://[seu-dominio-vercel]/api/webhooks/shopify-certificado`
   - **Format**: JSON
   - **API Version**: 2024-01
3. Guardar o **Webhook Secret** e adicionar a `.env.local`

### 4. Testar

```bash
# Health check
curl https://[seu-dominio-vercel]/api/webhooks/shopify-certificado

# Testar webhook (criar encomenda de teste no Shopify)
```

## Estrutura do Projeto

```
app/
└── api/
    └── webhooks/
        └── shopify-certificado/
            └── route.ts      # Handler do webhook
```

## URL do Certificado

Formato: `https://certificado-exportacao.vercel.app/download/{ORDER_NUMBER}`

Exemplo: `https://certificado-exportacao.vercel.app/download/12345`

## Troubleshooting

### Webhook não está a funcionar
1. Verificar se URL está correta no Shopify
2. Verificar logs no Vercel: `vercel logs --json`
3. Confirmar que HMAC está a ser verificado (ou desativar para teste)

### API retorna 401
- Verificar se `SHOPIFY_API_KEY` e `SHOPIFY_API_SECRET` estão corretos
- Confirmar que a app tem permissões para editar encomendas

### Metafield não aparece
- Verificar se o tema/admin mostra metafields
- Pode ser necessário atualizar visibilidade do metafield na Shopify

## Segurança

- ✅ HMAC verification ativa (opcional mas recomendada)
- ✅ API keys guardadas em 1Password
- ✅ Nunca fazer commit de `.env.local`

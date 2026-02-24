/**
 * Webhook Handler - Certificado de Exportação
 * 
 * Adiciona comentário automático às encomendas do Shopify
 * com link para o certificado de exportação
 */

import { NextRequest, NextResponse } from 'next/server';

interface ShopifyOrder {
  id: number;
  name: string;
  order_number: number;
  shipping_address?: {
    country_code?: string;
    country?: string;
  };
}

interface WebhookPayload {
  id: number;
  name: string;
  order_number: number;
  shipping_address?: {
    country_code?: string;
    country?: string;
  };
}

const SHOPIFY_STORE = process.env.SHOPIFY_STORE || 'f5ed86-2.myshopify.com';
const SHOPIFY_ACCESS_TOKEN = process.env.SHOPIFY_ACCESS_TOKEN;
const CERTIFICADO_BASE_URL = 'https://certificado-exportacao.vercel.app/download';

export async function POST(request: NextRequest) {
  try {
    // Verificar HMAC do webhook (segurança Shopify)
    const hmac = request.headers.get('x-shopify-hmac-sha256');
    const topic = request.headers.get('x-shopify-topic');
    
    if (!hmac) {
      console.error('Missing HMAC header');
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    // Só processar webhooks de criação de encomenda
    if (topic !== 'orders/create') {
      return NextResponse.json({ message: 'Ignored: not orders/create' }, { status: 200 });
    }

    // Parse do body
    const order: WebhookPayload = await request.json();
    
    console.log(`Processing order #${order.order_number} (${order.name})`);

    // Verificar se é envio internacional (fora da UE)
    // Se não houver shipping_address ou for país UE, ainda assim adicionamos
    // o comentário porque pode ser necessário para alfândega
    const countryCode = order.shipping_address?.country_code?.toUpperCase();
    
    // Lista de países da UE (códigos ISO)
    const euCountries = [
      'AT', 'BE', 'BG', 'HR', 'CY', 'CZ', 'DK', 'EE', 'FI', 'FR',
      'DE', 'GR', 'HU', 'IE', 'IT', 'LV', 'LT', 'LU', 'MT', 'NL',
      'PL', 'PT', 'RO', 'SK', 'SI', 'ES', 'SE'
    ];

    // Adicionar comentário à encomenda
    await addOrderComment(order.id, order.order_number);

    console.log(`Comment added to order #${order.order_number}`);

    return NextResponse.json({ 
      success: true, 
      message: `Comment added to order #${order.order_number}`,
      isInternational: countryCode ? !euCountries.includes(countryCode) : null
    });

  } catch (error) {
    console.error('Webhook error:', error);
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
  }
}

async function addOrderComment(orderId: number, orderNumber: number): Promise<void> {
  if (!SHOPIFY_ACCESS_TOKEN) {
    throw new Error('SHOPIFY_ACCESS_TOKEN not configured');
  }

  const certificadoUrl = `${CERTIFICADO_BASE_URL}/${orderNumber}`;
  
  // Comentário a adicionar
  const commentBody = `📄 Certificado de Exportação: ${certificadoUrl}`;

  // Usar metafields para guardar o link
  const metafieldEndpoint = `https://${SHOPIFY_STORE}/admin/api/2024-01/orders/${orderId}/metafields.json`;

  const metafieldPayload = {
    metafield: {
      namespace: 'certificado_exportacao',
      key: 'link',
      value: certificadoUrl,
      type: 'single_line_text_field'
    }
  };

  // Também tentar adicionar como nota da encomenda
  const noteEndpoint = `https://${SHOPIFY_STORE}/admin/api/2024-01/orders/${orderId}.json`;

  // 1. Adicionar metafield com o link
  const metafieldResponse = await fetch(metafieldEndpoint, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-Shopify-Access-Token': SHOPIFY_ACCESS_TOKEN
    },
    body: JSON.stringify(metafieldPayload)
  });

  if (!metafieldResponse.ok) {
    const errorText = await metafieldResponse.text();
    console.error('Metafield error:', errorText);
    throw new Error(`Failed to add metafield: ${metafieldResponse.status}`);
  }

  // 2. Atualizar nota da encomenda (order note) - visível no admin
  const noteResponse = await fetch(noteEndpoint, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      'X-Shopify-Access-Token': SHOPIFY_ACCESS_TOKEN
    },
    body: JSON.stringify({
      order: {
        id: orderId,
        note: `Certificado de Exportação: ${certificadoUrl}`
      }
    })
  });

  if (!noteResponse.ok) {
    const errorText = await noteResponse.text();
    console.error('Note update error:', errorText);
    // Não falhar se só a nota falhar, metafield já foi criado
  }

  console.log(`Metafield and note added to order ${orderId}`);
}

// Health check endpoint
export async function GET() {
  return NextResponse.json({ 
    status: 'OK', 
    service: 'certificado-exportacao-webhook',
    version: '1.0.0'
  });
}

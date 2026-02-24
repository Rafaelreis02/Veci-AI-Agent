/**
 * Webhook Handler - Certificado de Exportação
 * 
 * Adiciona comentário automático às encomendas do Shopify
 * com link para o certificado de exportação
 */

import { NextRequest, NextResponse } from 'next/server';

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
  console.log('🔔 Webhook received at:', new Date().toISOString());
  
  try {
    // Log headers para debug
    const topic = request.headers.get('x-shopify-topic');
    const hmac = request.headers.get('x-shopify-hmac-sha256');
    
    console.log('📋 Topic:', topic);
    console.log('🔑 HMAC present:', !!hmac);

    // Só processar webhooks de criação de encomenda
    if (topic !== 'orders/create') {
      console.log('⏭️ Ignored: not orders/create');
      return NextResponse.json({ message: 'Ignored: not orders/create' }, { status: 200 });
    }

    // Verificar se Access Token está configurado
    if (!SHOPIFY_ACCESS_TOKEN) {
      console.error('❌ SHOPIFY_ACCESS_TOKEN not configured');
      return NextResponse.json({ error: 'Server not configured' }, { status: 500 });
    }

    // Parse do body
    let order: WebhookPayload;
    try {
      order = await request.json();
    } catch (parseError) {
      console.error('❌ Failed to parse webhook body:', parseError);
      return NextResponse.json({ error: 'Invalid JSON' }, { status: 400 });
    }
    
    console.log(`📦 Processing order #${order.order_number} (${order.name}), ID: ${order.id}`);

    // Adicionar comentário à encomenda
    try {
      await addOrderComment(order.id, order.order_number);
      console.log(`✅ Comment added to order #${order.order_number}`);
    } catch (apiError) {
      console.error('❌ Failed to add comment:', apiError);
      return NextResponse.json({ 
        error: 'Failed to update order', 
        details: apiError instanceof Error ? apiError.message : 'Unknown error'
      }, { status: 500 });
    }

    return NextResponse.json({ 
      success: true, 
      message: `Comment added to order #${order.order_number}`
    });

  } catch (error) {
    console.error('❌ Webhook error:', error);
    return NextResponse.json({ 
      error: 'Internal server error',
      details: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500 });
  }
}

async function addOrderComment(orderId: number, orderNumber: number): Promise<void> {
  const certificadoUrl = `${CERTIFICADO_BASE_URL}/${orderNumber}`;
  
  console.log(`🔗 Certificate URL: ${certificadoUrl}`);

  // 1. Adicionar metafield com o link
  const metafieldEndpoint = `https://${SHOPIFY_STORE}/admin/api/2024-01/orders/${orderId}/metafields.json`;

  const metafieldPayload = {
    metafield: {
      namespace: 'certificado_exportacao',
      key: 'link',
      value: certificadoUrl,
      type: 'single_line_text_field'
    }
  };

  console.log(`📤 Sending metafield request to: ${metafieldEndpoint}`);

  const metafieldResponse = await fetch(metafieldEndpoint, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-Shopify-Access-Token': SHOPIFY_ACCESS_TOKEN!
    },
    body: JSON.stringify(metafieldPayload)
  });

  const metafieldResponseText = await metafieldResponse.text();
  console.log(`📥 Metafield response status: ${metafieldResponse.status}`);
  console.log(`📥 Metafield response body: ${metafieldResponseText}`);

  if (!metafieldResponse.ok) {
    throw new Error(`Failed to add metafield: ${metafieldResponse.status} - ${metafieldResponseText}`);
  }

  // 2. Atualizar nota da encomenda (order note) - visível no admin
  const noteEndpoint = `https://${SHOPIFY_STORE}/admin/api/2024-01/orders/${orderId}.json`;

  console.log(`📤 Sending note update to: ${noteEndpoint}`);

  const noteResponse = await fetch(noteEndpoint, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      'X-Shopify-Access-Token': SHOPIFY_ACCESS_TOKEN!
    },
    body: JSON.stringify({
      order: {
        id: orderId,
        note: `Certificado de Exportação: ${certificadoUrl}`
      }
    })
  });

  const noteResponseText = await noteResponse.text();
  console.log(`📥 Note response status: ${noteResponse.status}`);
  console.log(`📥 Note response body: ${noteResponseText}`);

  if (!noteResponse.ok) {
    console.error(`⚠️ Note update failed but metafield succeeded: ${noteResponse.status}`);
  }

  console.log(`✅ Metafield and note processed for order ${orderId}`);
}

// Health check endpoint
export async function GET() {
  return NextResponse.json({ 
    status: 'OK', 
    service: 'certificado-exportacao-webhook',
    version: '1.1.0',
    configured: !!SHOPIFY_ACCESS_TOKEN
  });
}

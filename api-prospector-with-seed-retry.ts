import { NextRequest, NextResponse } from 'next/server';
import { getServerSession } from 'next-auth/next';
import { authOptions } from '@/lib/auth';
import { prisma } from '@/lib/prisma';
import { logger } from '@/lib/logger';
import { GoogleGenerativeAI } from '@google/generative-ai';

// ... (mantenho o resto do código igual até à função getSeedFromDB)

// Nova função: tentar múltiplas seeds
async function findWorkingSeed(language: string, maxAttempts = 5): Promise<any | null> {
  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    const seed = await getSeedFromDB(language);
    if (!seed) return null;

    logger.info(`[PROSPECTOR] Trying seed ${attempt + 1}/${maxAttempts}: @${seed.tiktokHandle}`);

    try {
      // Testar se a seed tem following
      const profile = await scrapeProfile(seed.tiktokHandle);
      const followingCount = profile[0]?.authorMeta?.following || 0;

      if (followingCount > 0) {
        logger.info(`[PROSPECTOR] Seed @${seed.tiktokHandle} has ${followingCount} following ✓`);
        return { seed, profile };
      } else {
        logger.warn(`[PROSPECTOR] Seed @${seed.tiktokHandle} has no visible following, trying next...`);
      }
    } catch (err: any) {
      logger.warn(`[PROSPECTOR] Seed @${seed.tiktokHandle} failed: ${err.message}, trying next...`);
    }
  }

  return null;
}

// ... (resto do código)

// No handler POST, substituir a lógica de seed:
    // 1. FIND WORKING SEED
    let seedData, seedProfile;
    
    if (seed) {
      // Usar seed específica
      seedData = { name: seed, tiktokHandle: seed, tiktokFollowers: 0 };
      try {
        seedProfile = await scrapeProfile(seedData.tiktokHandle);
      } catch (err: any) {
        return NextResponse.json({ error: `Failed to scrape specified seed: ${err.message}` }, { status: 500 });
      }
    } else {
      // Tentar múltiplas seeds automaticamente
      const workingSeed = await findWorkingSeed(language.toUpperCase());
      if (!workingSeed) {
        return NextResponse.json({ 
          error: `No working seed found for language ${language} after trying multiple options. Please specify a seed manually.` 
        }, { status: 404 });
      }
      seedData = workingSeed.seed;
      seedProfile = workingSeed.profile;
    }

    const followingCount = seedProfile[0]?.authorMeta?.following || 0;
    // ... (resto igual)

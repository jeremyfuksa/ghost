import GhostContentAPI from '@tryghost/content-api';
import type { GhostPost, GhostTag } from './ghost.types';

const url = import.meta.env.GHOST_URL || process.env.GHOST_URL;
const key = import.meta.env.GHOST_CONTENT_API_KEY || process.env.GHOST_CONTENT_API_KEY;

if (!url || !key) {
  throw new Error(
    'GHOST_URL and GHOST_CONTENT_API_KEY must be set in site/.env',
  );
}

const api = new GhostContentAPI({
  url,
  key,
  version: 'v5.0',
});

export async function getAllPosts(): Promise<GhostPost[]> {
  const posts = await api.posts.browse({
    limit: 'all',
    include: ['tags', 'authors'],
    order: 'published_at desc',
  });
  return posts as unknown as GhostPost[];
}

export async function getPostBySlug(slug: string): Promise<GhostPost | null> {
  try {
    const post = await api.posts.read(
      { slug },
      { include: ['tags', 'authors'] },
    );
    return post as unknown as GhostPost;
  } catch (err) {
    const e = err as { type?: string; response?: { status?: number } };
    if (e.type === 'NotFoundError' || e.response?.status === 404) return null;
    throw err;
  }
}

export async function getPostsByTag(tagSlug: string): Promise<GhostPost[]> {
  const posts = await api.posts.browse({
    limit: 'all',
    filter: `tag:${tagSlug}`,
    include: ['tags', 'authors'],
    order: 'published_at desc',
  });
  return posts as unknown as GhostPost[];
}

export async function getAllTags(): Promise<GhostTag[]> {
  const tags = await api.tags.browse({
    limit: 'all',
    order: 'count.posts desc',
    include: ['count.posts'],
  });
  return tags as unknown as GhostTag[];
}

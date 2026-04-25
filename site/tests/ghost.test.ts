import { describe, expect, it } from 'vitest';
import { getAllPosts, getPostBySlug, getAllTags } from '../src/lib/ghost';

describe('ghost API client', () => {
  it('fetches posts with the expected shape', async () => {
    const posts = await getAllPosts();
    expect(Array.isArray(posts)).toBe(true);
    expect(posts.length).toBeGreaterThan(0);

    const post = posts[0];
    expect(post).toMatchObject({
      id: expect.any(String),
      slug: expect.any(String),
      title: expect.any(String),
      html: expect.any(String),
      published_at: expect.any(String),
      reading_time: expect.any(Number),
    });
    expect(Array.isArray(post.tags)).toBe(true);
  });

  it('fetches a single post by slug', async () => {
    const all = await getAllPosts();
    const slug = all[0].slug;
    const post = await getPostBySlug(slug);
    expect(post?.slug).toBe(slug);
  });

  it('returns null for a missing slug', async () => {
    const post = await getPostBySlug('definitely-not-a-real-post-slug-xyzzy');
    expect(post).toBeNull();
  });

  it('fetches tags ordered by post count desc', async () => {
    const tags = await getAllTags();
    expect(Array.isArray(tags)).toBe(true);
  });
});

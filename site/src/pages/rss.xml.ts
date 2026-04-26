import rss from '@astrojs/rss';
import type { APIContext } from 'astro';
import { getAllPosts } from '~/lib/ghost';

export async function GET(context: APIContext) {
  const posts = await getAllPosts();
  return rss({
    title: 'The Cocktail Napkin — Jeremy Fuksa',
    description: 'Essays and notes on design, AI, and design systems.',
    site: context.site!,
    items: posts.map((post) => ({
      title: post.title,
      description: post.custom_excerpt ?? post.excerpt,
      pubDate: new Date(post.published_at),
      link: `/writing/${post.slug}/`,
      content: post.html,
    })),
    customData: '<language>en-us</language>',
  });
}

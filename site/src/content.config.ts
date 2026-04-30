import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const factSchema = z.object({
  label: z.string(),
  value: z.string(),
});

const statSchema = z.object({
  value: z.string(),
  label: z.string(),
});

const linkSchema = z.object({
  label: z.string(),
  href: z.string().url(),
});

const caseStudies = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/case-studies' }),
  schema: ({ image }) =>
    z.object({
      title: z.string(),
      eyebrow: z.string(),
      tagline: z.string(),
      role: z.string(),
      organization: z.string().optional(),
      timeline: z.string(),
      pullquote: z.string().optional(),
      facts: z.array(factSchema).optional(),
      stats: z.array(statSchema).optional(),
      links: z.array(linkSchema).optional(),
      readingTime: z.number().optional(),
      order: z.number(),
      excerpt: z.string(),
      coverImage: image().optional(),
      coverImageAlt: z.string().optional(),
    }),
});

export const collections = { 'case-studies': caseStudies };

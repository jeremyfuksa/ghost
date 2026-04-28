import { defineCollection, z } from 'astro:content';

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
  type: 'content',
  schema: z.object({
    title: z.string(),
    eyebrow: z.string(),         // e.g. "Systems work · 2018–2024"
    tagline: z.string(),         // HTML allowed for <em>
    role: z.string(),
    organization: z.string().optional(),
    timeline: z.string(),
    pullquote: z.string().optional(),
    facts: z.array(factSchema).optional(),
    stats: z.array(statSchema).optional(),
    links: z.array(linkSchema).optional(),
    readingTime: z.number().optional(),  // minutes; falls back to MDX-derived
    order: z.number(),                   // for /work/ list ordering
    excerpt: z.string(),                 // for og:description and /work/ list
  }),
});

export const collections = { 'case-studies': caseStudies };

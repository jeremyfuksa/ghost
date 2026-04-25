export interface GhostTag {
  id: string;
  slug: string;
  name: string;
  url: string;
  count?: { posts: number };
}

export interface GhostAuthor {
  id: string;
  slug: string;
  name: string;
  bio?: string;
  profile_image?: string;
  url: string;
}

export interface GhostPost {
  id: string;
  slug: string;
  title: string;
  html: string;
  excerpt: string;
  custom_excerpt: string | null;
  feature_image: string | null;
  feature_image_caption: string | null;
  featured: boolean;
  published_at: string;
  updated_at: string;
  reading_time: number;
  url: string;
  tags: GhostTag[];
  primary_tag: GhostTag | null;
  authors: GhostAuthor[];
  primary_author: GhostAuthor | null;
}

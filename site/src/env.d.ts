/// <reference path="../.astro/types.d.ts" />

declare module '@tryghost/content-api';

interface ImportMetaEnv {
  readonly GHOST_URL: string;
  readonly GHOST_CONTENT_API_KEY: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}

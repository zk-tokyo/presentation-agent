import { defineConfig } from 'vite'

// Local preview fix: Slidev 52.x (rolldown-vite) ships a `slide-import-guard`
// plugin that rejects public-asset imports like `<img src="/images/logo.png">`
// when `server.fs.strict` is true, breaking `bun dev` / `bun run build`.
// Relaxing fs.strict lets the cover-logo public assets resolve. This only
// affects the dev server's filesystem access policy, not the rendered output.
export default defineConfig({
  server: {
    fs: {
      strict: false,
    },
  },
})

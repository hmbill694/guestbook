// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

import node from '@astrojs/node';

// https://astro.build/config
export default defineConfig({
	vite: {
		plugins: [tailwindcss()],
	},

	adapter: node({
		mode: 'standalone',
	}),

	// TLS ends at the reverse proxy, so the server sees plain http. Trusting the
	// proxy's X-Forwarded-Proto for this host lets the form POST origin check match.
	security: {
		allowedDomains: [{ hostname: 'guestbook.underhive.tech', protocol: 'https' }],
	},
});

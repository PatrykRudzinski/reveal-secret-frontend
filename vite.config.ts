import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

export default defineConfig({
	plugins: [sveltekit()],
	envDir: './.envs/',
	server: {
		port: 5173,
	  },
	  preview: {
		port: 5173,
	  },
});

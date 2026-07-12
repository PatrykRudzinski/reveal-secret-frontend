# Reveal Secret — Frontend

SvelteKit app for creating and revealing one-time secrets.

## Setup

```bash
npm install
cp .envs/.env.example .envs/.env
```

Set `VITE_API_URL` to point at the backend API.

## Run

```bash
npm run dev
```

Dev server runs at http://localhost:5173

## Deploy

```bash
npm run build
PORT=5173 HOST=localhost node build/index.js
```

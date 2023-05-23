FROM node:latest

WORKDIR /app

COPY ./package*.json \
     ./svelte.config.js \
     ./tsconfig.json \
     ./vite.config.ts \
     ./.npmrc \
     ./

ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

RUN npm install

COPY ./.envs/ ./.envs/
COPY ./static/ ./static/
COPY ./src/ ./src/

CMD if [ "${NODE_ENV}" = "production" ]; \
    then \
      npm run build && npm run start -- --host; \
    else \
      npm run dev -- --host; \
    fi

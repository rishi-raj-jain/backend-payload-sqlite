FROM node:22-alpine AS base

# Install pnpm 10 explicitly and enable corepack
FROM base AS deps
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@10.0.0 --activate
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN corepack enable && corepack prepare pnpm@10.0.0 --activate && pnpm run build

FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production

# Only copy the directories if they exist, to avoid build errors
RUN if [ -d /app/.next/standalone ]; then cp -r /app/.next/standalone . ; fi
RUN if [ -d /app/.next/static ]; then mkdir -p .next && cp -r /app/.next/static .next/ ; fi
RUN if [ -d /app/public ]; then cp -r /app/public ./public ; fi

ENV PORT=80
EXPOSE 80

CMD ["node", "server.js"]

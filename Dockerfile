FROM node:22-alpine AS base

FROM base AS deps
WORKDIR /app
RUN corepack enable && pnpm i -g pnpm@10 && pnpm i

FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN corepack enable && pnpm run build

FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

ENV PORT=80
EXPOSE 80

CMD ["node", "server.js"]

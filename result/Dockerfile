FROM node:18.18-alpine

ENV NODE_ENV production

WORKDIR /usr/src/app

# dependances -cache)
COPY package*.json ./
RUN --mount=type=cache,target=/usr/src/app/.npm \
    npm set cache /usr/src/app/.npm && \
    npm ci --only=production

# user non root
USER node

COPY --chown=node:node . .

EXPOSE 8888

CMD ["node", "server.js"]

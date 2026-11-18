FROM node:18.20

RUN adduser --system --shell /usr/sbin/nologin --group --no-create-home app

WORKDIR /app/node/result/

COPY --chown=app:app ./result/package*.json /app/node/result/

RUN --mount=type=cache,target=/root/.npm \
    npm ci

COPY --chown=app:app ./result/ .

USER app

EXPOSE 3000

CMD ["npm", "start"]
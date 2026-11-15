FROM node:18.20

RUN adduser --system --shell /usr/sbin/nologin --group --no-create-home app

WORKDIR /app/node/result/

COPY --chown=app:app ./result/ .

RUN npm install

USER app

EXPOSE 3000

CMD ["npm", "start"]
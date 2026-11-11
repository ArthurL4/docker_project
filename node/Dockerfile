FROM node:18.20

RUN apt update -y

WORKDIR /app/node/

COPY ./result/ .

RUN npm install

EXPOSE 3000

CMD ["npm", "start"]
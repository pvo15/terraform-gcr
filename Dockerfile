FROM node:14.15.3

MAINTAINER pvo

WORKDIR /app

COPY . .


RUN npm install


EXPOSE 8080

CMD ["node", "index.js"]
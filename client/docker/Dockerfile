FROM node:10-alpine AS builder

COPY . /usr/app/client/

WORKDIR /usr/app/client

RUN npm install -g @angular/cli@6.1.5 && npm install && ng build --prod

FROM nginx:1.27.0-alpine

RUN apk add curl

COPY ./docker/nginx.conf /etc/nginx.conf
COPY --from=builder /usr/app/client/dist /usr/share/nginx/html/







FROM node:12.7-alpine AS initialize-app
WORKDIR /app
COPY package.json ./
RUN npm install

FROM initialize-app AS build-app
COPY . .
ARG environment
RUN  $(npm bin)/ng build --configuration=$environment

FROM nginx:1.16-alpine as nginx-stage
COPY --from=build-app /app/dist/angular-environments /usr/share/nginx/html
EXPOSE 80
CMD [ "nginx","-g","daemon off;" ]
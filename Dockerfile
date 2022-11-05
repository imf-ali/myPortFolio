FROM node:18-alpine AS builder
WORKDIR /app

COPY package.json package.json
RUN npm install
COPY . .

RUN npm run build

FROM httpd:alpine
WORKDIR /usr/local/apache2/htdocs
COPY --from=build /app/build/ .
RUN chown -R www-data:www-data /usr/local/apache2/htdocs \
    && sed -i "s/Listen 80/Listen \${PORT}/g" /usr/local/apache2/conf/httpd.conf
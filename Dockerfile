# Stage 1: Build the application
FROM node:16.17.0-alpine as builder
WORKDIR /app
COPY ./package.json .
COPY ./yarn.lock .
RUN yarn install
COPY . .
ARG TRAKT_CLIENT_ID
ARG TRAKT_CLIENT_SECRET
ENV VITE_APP_TRAKT_CLIENT_ID=${TRAKT_CLIENT_ID}
ENV VITE_APP_TRAKT_CLIENT_SECRET=${TRAKT_CLIENT_SECRET}
RUN yarn build

# Stage 2: Create the production image
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/dist .
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]

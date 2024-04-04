# Stage 1: Dependency installation stage
FROM node:21-alpine as dependencies

WORKDIR /app
COPY ./package*.json ./
RUN npm install

# Stage 2: Build stage
FROM node:21-alpine as builder
WORKDIR /app
COPY --from=dependencies /app/package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 3: Production stage
FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html
COPY --from=builder /app/build .
ENTRYPOINT ["nginx", "-g", "daemon off;"]
